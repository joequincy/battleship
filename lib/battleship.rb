require './lib/board'
require './lib/ship'
require './lib/player'
require './lib/computer'
require 'pry'

class Battleship
  def initialize
    @computer_board = Board.new
    @user_board = Board.new
    @computer = Computer.new(@computer_board, @user_board)
    @user = Player.new(@user_board, @computer_board)
    @game_over = false
    @current_player = @computer
  end

  def run
    loop do
      display_main_menu
      setup
      play_game
      end_game
    end
  end

  def display_main_menu
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    user_response = gets.chomp.downcase

    while user_response != "p"
      if user_response == "q"
        abort
      else
        puts "Invalid response."
      end
      user_response = gets.chomp.downcase
    end
  end

  def setup
    ships = @user.generate_ships
    computer_ships = ships.map{|ship| ship.clone}

    @computer.place_ships(computer_ships)
    @user.place_ships(ships)
  end

  def play_game
    until @game_over
      toggle_player
      if @current_player == @user
        puts "===Computer Board==="
        puts @computer_board.render
        puts "====Player Board===="
        puts @user_board.render(true)
      end
      @game_over = @current_player.take_shot
    end
  end

  def toggle_player
    if @current_player == @user
      @current_player = @computer
    else
      @current_player = @user
    end
  end

  def end_game
    if @current_player == @user
      puts "You won!"
    else
      puts "I won!"
    end

    # Reset Instance Variables
    @computer_board = Board.new
    @user_board = Board.new
    @computer = Computer.new(@computer_board, @user_board)
    @user = Player.new(@user_board, @computer_board)
    @game_over = false
    @current_player = @computer
  end
end
