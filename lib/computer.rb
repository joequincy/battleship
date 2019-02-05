class Computer
  attr_reader :ships,
              :own_board,
              :enemy_board

  def initialize(own_board, enemy_board)
    @own_board = own_board
    @enemy_board = enemy_board
    @ships = []
    @untargeted_spaces = enemy_board.cells.keys
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
    ships.each do |ship|
      begin
        coordinates = guess_consecutive_coordinates(ship)
        success = @own_board.place(ship, coordinates)
      end until success
    end
  end

  def guess_consecutive_coordinates(ship)
    output = [@own_board.cells.keys.sample]
    starting_coordinate = output.first.split("")
    direction = rand(2)
    distance = ship.length - 1
    (1..distance).each do |step|
      next_coordinate = []
      if direction == 0
        next_coordinate << starting_coordinate.first
        next_coordinate << starting_coordinate.last + step
      else
        next_coordinate << (starting_coordinate.first.ord + step).char
        next_coordinate << starting_coordinate.last
      end
      output << next_coordinate.join("")
    end
    return output
  end

  def take_shot
    # take_shot does not take any arguments
    #
    # it walks the user through taking a shot
    # then displays the result
    #
    # it returns `true` if the shot won the game
    # it returns `false` if the game must continue

  end

  def display_result(result)
    puts "My shot on #{result[:coordinate]} was a #{result[:outcome]}"
    if result[:outcome] == "hit"
      check_for_winner
    else
      false
    end
  end

  def check_for_winner
    @enemy_board.all_ships_sunk?
  end
end
