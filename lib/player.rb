require './lib/converters'

class Player
  attr_reader :ships
  def initialize(own_board, enemy_board)
    @own_board = own_board
    @enemy_board = enemy_board
    @ships = []
  end

  def place_ships(ships)
    # @ships = ships.map{|ship| ship.clone}
    @ships = ships.clone
    while ships.length > 0
      print_ship_list(ships)
      puts @own_board.render(true)
      current_ship = ships.shift
      validation_check = {pass: false}
      until validation_check[:pass]
        puts "Enter the squares for the #{current_ship.name} (#{current_ship.length} spaces):"
        coords = gets.chomp.upcase.split(" ")
        validation_check = @own_board.place(current_ship, coords)
        if !validation_check[:pass]
          puts "Invalid placement:"
          puts validation_check[:msg]
        end
      end
      system "clear && printf '\e[3J'"
      puts "The #{current_ship.name} has been placed!"
      puts ""
    end
  end

  def get_ships
    available_spaces = [
      get_num_ship_spaces,
      5
    ].max.to_i
    while available_spaces > 0
      if ships.length > 0
        puts "Your current ships:"
        print_ship_list(ships)
        puts ""
      end
      length_limit = [@own_board.width, @own_board.height, available_spaces].max
      puts "You have #{available_spaces.to_words} unit#{length_limit > 1 ? "s" : ""} available."
      print "What will you call your next ship? >"
      ship_name = normalize_ship_name(gets.chomp)
      ship_length = 0
      while ship_length == 0
        print "How long is it? >"
        ship_length = gets.chomp.to_i
        if ship_length > length_limit
          ship_length = 0
          puts "That's too long for this board. Maximum ship length is #{available_spaces}."
        elsif ship_length <= 0
          ship_length = 0
          puts "That's an invalid length."
        end
      end
      ships << Ship.new(ship_name, ship_length)
      available_spaces -= ship_length
      system "clear && printf '\e[3J'"
    end
    return ships
  end

  def normalize_ship_name(name)
    name.split(" ").each do |word|
      word.capitalize!
    end.join(" ")
  end

  def print_ship_list(ships)
    puts "Your remaining ships to place are:\n"
    types = ships.uniq{|ship| ship.name}
    types.each do |type|
      ships_of_type = ships.count{|ship| ship.name == type.name}
      puts "#{ships_of_type}x #{type.name} (#{type.length} units long)\n"
    end
  end

  def take_shot
    puts "Enter the coordinate for your shot:"
    user_response = gets.chomp.upcase
    result = @enemy_board.fire_upon(user_response)
    while result.class == String
      puts "#{result} Please enter a valid coordinate:"
      user_response = gets.chomp.upcase
      result = @enemy_board.fire_upon(user_response)
    end

    return {
       msg: " shot on #{user_response} was a #{result[:msg]}.",
      sunk: result[:sunk],
      ship: result[:ship]
    }
  end

  def generate_ships
    ships = []
    if @own_board.width == 4 && @own_board.height == 4
      ships = [
               Ship.new("Cruiser", 3),
               Ship.new("Submarine", 2)
              ]
    elsif @own_board.width == 10 && @own_board.height == 10
      ships = [
               Ship.new("Aircraft Carrier", 5),
               Ship.new("Battleship", 4),
               Ship.new("Cruiser", 3),
               Ship.new("Submarine", 3),
               Ship.new("Destroyer", 2)
              ]
    else
      spaces = get_num_ship_spaces
      ships = create_ship_set(spaces).sort do |a,b|
        if b.length > a.length
          1
        elsif a.length > b.length
          -1
        else
          a.name <=> b.name
        end
      end
    end
    return ships
  end

  def get_num_ship_spaces
    spaces = @own_board.width * @own_board.height
    if spaces <= 16
      5
    elsif spaces >= 100
      (spaces * 0.17).to_i
    else
      max_ratio = 5.0 / 16
      ratio_increment = 19.0 / 11200 # simplified to a single division operation
      total_ratio = max_ratio - (spaces - 16) * ratio_increment
      (spaces * total_ratio).to_i
    end
  end

  def create_ship_set(num)
    # puts "Creating a ship set for #{num} ships."
    ships = []
    if num == 0
      return ships
    elsif num > 999
      return "Way too many"
    end
    bases = {
      17 => Ship.new("Aircraft Carrier", 5),
      12 => Ship.new("Battleship", 4),
      8 => Ship.new("Cruiser", 3),
      5 => Ship.new("Submarine", 3),
      4 => Ship.new("Destroyer", 2),
      3 => Ship.new("Submarine", 3),
      2 => Ship.new("Destroyer", 2),
      1 => Ship.new("Minesweeper", 1)
    }
    bases.each do |int, ship|
      if num > 18
        ships += create_ship_set(num - int)
        ships += create_ship_set(int)
        return ships
      elsif num == 18
        ships << Ship.new("Destroyer", 2)
        ships += create_ship_set(16)
        return ships
      elsif num % int == 0
        ships << ship
        ships += create_ship_set(num - ship.length)
        return ships
      elsif num / int > 0 && num < 17
        ships << ship
        ships += create_ship_set(num - ship.length)
        return ships
      end
    end
  end
end

# wipe out entire terminal:
# system "clear && printf '\e[3J'"
