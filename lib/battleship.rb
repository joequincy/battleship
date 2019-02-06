require './lib/board'
require './lib/player'
require './lib/computer'

class Battleship
  def initialize
    @boards = []
    @players = []
    @winner = nil
    @computer_opponent = 0
  end

  def start
    loop do
      main_menu
      setup
      play
    end
  end

  def main_menu
    clear_terminal
    puts "Welcome to Battleship!"
    puts "Enter 'p' to play, or enter 'q' to quit."
    user_response = gets.chomp.downcase
    if user_response != "p" && user_response != "play"
      puts "Are you sure you want to quit? 'y' or 'n'"
      abort_response = gets.chomp.downcase
      if abort_response != "n" && abort_response != "no"
        abort
      end
    end
    clear_terminal
    puts "Do you want to play against another person?"
    puts "Enter 'y' to play against a person, or 'n'\nto play against the computer."
    user_response = gets.chomp.downcase
    if user_response == "y" || user_response == "yes"
      @computer_opponent = false
    else
      # prompt the player what difficulty they'd like
      # puts "What difficulty would you like?"
      # puts "0: Computer fires at random."
      # puts "1: Computer is a little smarter about where to shoot."
      # puts "2: Computer is much smarter about where to shoot."
    end
    clear_terminal
  end

  def setup
    create_boards
    clear_terminal
    create_players
    ships = create_ships
    clear_terminal
    place_ships(ships)
    clear_terminal
  end

  def create_boards
    puts "Do you want to choose your board size? (default 4x4)"
    puts "Please enter 'y' or 'n'."
    user_response = gets.chomp
    if user_response == "yes" || user_response == "y"
      clear_terminal
      puts "Please enter a board size in the form #x#"
      puts "Your board must have no more than 400 cells." # sanity limit
      puts "You may also enter 'official' or 'o' to play with a 10x10 board."
      size = gets.chomp.downcase
      if size == "official" || size == "o"
        @boards << Board.new(10, 10)
        if @computer_opponent
          @boards << ComputerBoard.new(10, 10)
        else
          @boards << Board.new(10, 10)
        end
      else
        while @boards.length == 0
          dimensions = size.match(/^([0-9]+)x([0-9]+)$/)
          if dimensions.captures.length == 2
            x = dimensions[1].to_i
            y = dimensions[2].to_i
            if x > 3 && y > 3 && x + y >= 8 && x * y <= 400
              @boards << Board.new(x, y)
              if @computer_opponent
                @boards << ComputerBoard.new(x, y)
              else
                @boards << Board.new(x, y)
              end
            end
          end
          if @boards.length == 0
            puts "Those dimensions were invalid. Please try again."
            size = gets.chomp
          end
        end
      end
    else
      @boards << Board.new
      if @computer_opponent
        @boards << ComputerBoard.new
      else
        @boards << Board.new
      end
    end
  end

  def create_players
    @players << Player.new(@boards[0], @boards[1])
    if @computer_opponent
      @players << Computer.new(@boards[1], @boards[0], @computer_opponent)
    else
      @players << Player.new(@boards[1], @boards[0])
    end
  end

  def create_ships
    puts "Would you like to create your own ships?"
    puts "Please enter 'y' or 'n'."
    user_response = gets.chomp
    if user_response == "yes" || user_response == "y"
      @players[0].get_ships
    else
      @players[0].generate_ships
    end
  end

  def place_ships(ships)
    if @computer_opponent
      @players.reverse.each do |player|
        player.place_ships(ships)
      end
    else
      @players.each do |player|
        player.place_ships(ships)
        puts ""
        puts player.render_own_board
        hand_off_to_opponent
      end
    end
  end

  def play
    headers = get_board_headers
    near_side = 0
    far_side = 1
    last_shot = "All ships placed!\nThe battle begins!\n\n"
    until @winner do
      puts last_shot
      puts headers[:opponent]
      puts @boards[far_side].render
      puts ""
      puts headers[:player]
      puts @boards[near_side].render(true)
      puts ""
      # binding.pry
      this_shot = @players[near_side].take_shot
      clear_terminal
      puts "Your" + this_shot[:msg]
      if this_shot[:sunk]
        puts "You sunk my #{this_shot[:ship]}!"
      end
      puts ""
      # if !@players[far_side].ships.any?{|ship| !ship.sunk?}
      if @players[far_side].all_ships_sunk?
        @winner = @players[near_side]
      else
        # We haven't won yet!
        if @computer_opponent
          this_shot = @players[far_side].take_shot
          puts "My" + this_shot[:msg]
          if this_shot[:sunk]
            puts "I sunk your #{this_shot[:ship]}!"
            last_shot = "\n"
          else
            last_shot = "\n\n"
          end
          # if !@players[near_side].ships.any?{|ship| !ship.sunk?}
          if @players[near_side].all_ships_sunk?
            @winner = @players[far_side]
          end
        else
          puts headers[:opponent]
          puts @boards[far_side].render
          puts ""
          puts headers[:player]
          puts @boards[near_side].render(true)
          puts ""
          last_shot = "My" + this_shot[:msg]
          if this_shot[:sunk]
            last_shot += "\nI sunk your #{this_shot[:ship]}!"
          end
          near_side = (near_side - 1).abs
          far_side = (far_side - 1).abs
          hand_off_to_opponent
        end
      end
    end

    end_game
  end

  def get_board_headers
    headers = {}
    header_target_length = @boards[1].render.split("\n").first.length
    headers[:opponent] = @computer_opponent ? "==Computer Board==" : "==Opponent Board=="
    headers[:player] = "====Your Board===="
    if header_target_length > headers[:opponent].length
      headers[:opponent] = pad_center(headers[:opponent], header_target_length)
      headers[:player] = pad_center(headers[:player], header_target_length)
    end
    return headers
  end

  def end_game
    player_1_header = ""
    player_2_header = ""
    if @winner.class == Computer
      print "I won!"
      player_1_header = "==Computer Board=="
      player_2_header = "==Your Board=="
    else
      print "You win!"
      player_1_header = "==Player 1=="
      player_2_header = "==Player 2=="
    end
    print " Are you ready to see the final boards?\n"
    puts "Press Return to continue..."
    gets
    clear_terminal

    header_length = @boards[1].render.split("\n").first.length

    if @players[1].class == Computer
      puts pad_center(player_1_header, header_length)
      puts @boards[1].render(true)
      puts ""
      puts pad_center(player_2_header, header_length)
      puts @boards[0].render(true)
      puts ""
      if @winner.class == Computer
        puts "Better luck next time!"
      else
        puts "Congratulations!"
      end
    else
      puts pad_center(player_1_header, header_length)
      puts @boards[0].render(true)
      puts ""
      puts pad_center(player_2_header, header_length)
      puts @boards[1].render(true)
      puts ""
      puts "Good game, players!"
    end
    puts "\nPress Return to continue..."
    gets
    @boards = []
    @players = []
    @winner = nil
    @computer_opponent = 0
  end

  def hand_off_to_opponent
    puts "Please press Return when you are ready, then pass the computer to your opponent."
    gets
    clear_terminal
    puts "Please press Return when you are ready to begin your turn."
    gets
  end

  def pad_center(string, target_length)
    missing_chars = [target_length - string.length, 0].max
    left = (missing_chars / 2.0).floor
    right = (missing_chars / 2.0).ceil
    return ("=" * left) + string + ("=" * right)
  end

  def clear_terminal
    system "clear && printf '\e[3J'"
  end
end
