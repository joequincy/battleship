require './lib/board'
require './lib/ship'
require "./lib/player"
require 'pry'

class Battleship
  def initialize
    @boards = []
    @computer = Player.new(Board.new, Board.new)
    @user = Player.new(Board.new, Board.new)
    @game_over = false
  end

  def start
    # greeting, ask user if they want to play
    p "Welcome to BATTLESHIP"
    p "Enter p to play. Enter q to quit."
    user_response = gets.chomp
    if user_response == "q"
      !@game_over
    elsif user_response == "p"
      setup
    else
      p "Invalid key."
      start
    end
  end

    # until @game_over do
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
  #   end
  #
  #   end_game
  # end

  def setup
    # set up two boards
    players = [@user, @computer]
    # @boards << computer board
    # @boards << user board
    # ask @computer to place ships
    # ask @user to place ships

    players.each do |player|
      player.ships.each do |ship|
        coordinates = []
        puts "Place #{ship.name} (#{ship.length} cells)"
        puts "Enter first coordinate"
        first_coordinate = gets.chomp.capitalize
        coordinates << first_coordinate
        (ship.length - 1).times do
          puts 'Next Coordinate?'
          next_coordinate = gets.chomp.capitalize
          coordinates  << next_coordinate
        end
        validation_checks(player.own_board, ship, coordinates)
      end
    end
  end

  def validation_checks(board, ship, coordinates)
    valid_coordinates = coordinates.map do |coordinate|
      board.validate_coordinate?(coordinate)
    end

      if valid_coordinates.all? == false
        puts "#{"*" * 10} NOT VALID COORDINATES #{"*" * 10}"
        puts "\n"
        setup
      else

        valid_placement = board.valid_placement?(ship, coordinates)
        if valid_placement == true
          board.place(ship, coordinates)
          puts board.render(true)
        else
          puts "#{"*" * 10} NOT VALID PLACEMENT #{"*" * 10}"
          puts "\n"
          setup
        end
      end
    end

  def end_game
    # puts game results
    # reset instance variables
    start
  end
end
