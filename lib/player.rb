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

    # it walks the user through placing each Ship
    # onto the board

    # it does not have a return value
  end

  def get_ships
    # get_ships does not take any arguments

    # it walks the user through creating a custom
    # set of ships

    # it returns an array of Ship objects
  end

  def take_shot
    # take_shot does not take any arguments

    # it walks the user through taking a shot
    # then displays the result

    # it returns `true` if the shot won the game
    # it returns `false` if the game must continue
  end

  def generate_ships
    # generate_ships does not take any arguments

    # use this to get ships if the user does not want
    # to create their own

    # it returns an array of Ship objects
  end
end
