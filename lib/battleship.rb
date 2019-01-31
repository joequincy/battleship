require './lib/board'

class Battleship
  def initialize
    # @boards = []
    # @computer = Player.new("computer")
    # @user = Player.new("human")
    # @game_over = false
  end

  def start
    # greeting, ask user if they want to play
    # if 'q', stop execution
    # if 'p', continue
    setup

    until @game_over do
      # render computer board
      # render(true) user board

      # ask user to take shot
      # puts result of user's shot
      # check if all computer ships are sunk
      # if yes, change @game_over to "user"
      # break

      # ask computer to take shot
      # puts result of computer's shot
      # check if all user's ships are sunk
      # if yes, change @game_over to "computer"
    end

    end_game
  end

  def setup
    # set up two boards
    # @boards << computer board
    # @boards << user board
    # ask @computer to place ships
    # ask @user to place ships
  end

  def end_game
    # puts game results
    # reset instance variables
    start
  end
end
