require './lib/nums_to_words'
require './lib/ship'
require './lib/board'
require 'pry'

class Player
  def initialize(own_board, enemy_board)
    @own_board = own_board
    @enemy_board = enemy_board
  end

  def place_ships(ships = [])
    if ships.length == 0
      ships = [
               Ship.new("Cruiser", 3),
               Ship.new("Submarine", 2)
              ]
    end
    while ships.length > 0
      print_ship_list(ships)
      @own_board.render(true)
      current_ship = ships.shift
      ship_placed = false
      until ship_placed
        puts "Enter the squares for the #{current_ship.name} (#{current_ship.length} spaces):"
        coords = gets.chomp
        ship_placed = @own_board.place_ship(current_ship, coords)
      end
    end
  end

  def get_ships
    available_spaces = [
      @own_board.width * @own_board.height * 0.17,
      5
    ].max.to_i
    ships = []
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
      # system "clear && printf '\e[3J'"
      system "clear"
    end
    p ships
    return ships
  end

  def normalize_ship_name(name)
    name.split(" ").each do |word|
      word.capitalize!
    end.join(" ")
  end

  def print_ship_list(ships)
    str = "T"
    ships.each_index do |i|
      if i == ships.length - 1 && ships.length > 1
        str += ", and t"
      elsif i > 0
        str += ", t"
      end
      str += "he #{ships[i].name} is #{ships[i].length.to_words} units long"
    end
    str += "."
    str.scan(/([^\s].{1,80})(?= |$)+/).each do |line|
      puts line
    end
  end
end

w = 4
h = 4

player = Player.new(Board.new(w, h), Board.new(w, h))
player.get_ships

# wipe out entire terminal:
# system "clear && printf '\e[3J'"


# get ships
#   get max ship spaces, display to player
#   while spaces still available
#     get ship details from player
#     validate ship
#     add to list of ships
#   end
# end
#
# take shot
#   successful shot = false
#   until successful shot
#     ask user to enter shot coordinates
#     take shot
#   end
# end
