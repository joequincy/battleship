class Player
  attr_reader :ships
  def initialize(own_board, enemy_board)
    @own_board = own_board
    @enemy_board = enemy_board
    @ships = []
  end

  def place_ships(ships)
    # place_ships takes the following argument:
    #   `ships` is an array of Ship objects
    #
    # it walks the user through placing each Ship
    # onto the board
    #
    # it does not have a return value
    @ships = ships
    puts "The Cruiser is three units long and the Submarine is two units long."
    ships.each do |ship|
      puts @own_board.render(true)
      # print out our own board
      # prompt user to place first ship in array
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      begin
        user_response = gets.chomp.upcase.split(" ")
        success = @own_board.place(ship, user_response)
        if !success
          puts "Those are invalid coordinates. Please try again:"
        end
      end until success
    end
  end

  def take_shot
    # take_shot does not take any arguments
    #
    # it walks the user through taking a shot
    # then displays the result
    #
    # it returns `true` if the shot won the game
    # it returns `false` if the game must continue
    puts "Enter the coordinate for your shot:"
    begin
      user_response = gets.chomp.upcase
      result = @enemy_board.fire_upon(user_response)
      if !result
        puts "Please enter a valid coordinate:"
      elsif result[:outcome] == nil
        puts "You've already fired on this coordinate. Please choose another:"
        result = false
      end
    end until result
    display_result(result)
  end

  def display_result(result)
    puts "Your shot on #{result[:coordinate]} was a #{result[:outcome]}"
    if result[:outcome] == "hit" && result[:sunk]
      puts "You sunk my #{result[:sunk]}!"
      check_for_winner
    else
      false
    end
  end

  def check_for_winner
    @enemy_board.all_ships_sunk?
  end

  def generate_ships
    # generate_ships does not take any arguments
    #
    # use this to get ships if the user does not want
    # to create their own
    #
    # it returns an array of Ship objects
    [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
  end
end
