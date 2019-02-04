require './lib/board'
require './lib/player'
require './lib/computer'

class Battleship
  def initialize
    @boards = []
    @players = []
    @winner = nil
    @computer_opponent = true
  end

  def start
    system "clear && printf '\e[3J'"
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
    system "clear && printf '\e[3J'"
    puts "Do you want to play against another person?"
    puts "Enter 'y' to play against a person, or 'n'\nto play against the computer."
    user_response = gets.chomp.downcase
    if user_response == "y" || user_response == "yes"
      @computer_opponent = false
    else
      # prompt the player what difficulty they'd like
      #
    end
    system "clear && printf '\e[3J'"

    setup

    header_length = @boards[1].render.split("\n").first.length
    opponent_header = "==Opponent Board=="
    player_header = "===Your Board==="
    if header_length > opponent_header.length
      opponent_header = pad_center(opponent_header, header_length)
      player_header = pad_center(player_header, header_length)
    end
    near_side = 0
    far_side = 1
    last_shot = ""
    until @winner do
      puts ""
      print last_shot
      puts opponent_header
      puts @boards[far_side].render
      puts ""
      puts player_header
      puts @boards[near_side].render(true)
      puts ""
      # binding.pry
      this_shot = @players[near_side].take_shot
      system "clear && printf '\e[3J'"
      puts "Your" + this_shot[:msg]
      if this_shot[:sunk]
        puts "You sunk my #{this_shot[:ship]}!"
      end
      puts ""
      if @players[far_side].ships.any?{|ship| !ship.sunk?}
        if @computer_opponent
          this_shot = @players[far_side].take_shot
          puts "My" + this_shot[:msg]
          if this_shot[:sunk]
            puts "I sunk your #{this_shot[:ship]}!"
          end
          if !@players[near_side].ships.any?{|ship| !ship.sunk?}
            @winner = @players[far_side]
          end
        else
          puts opponent_header
          puts @boards[far_side].render
          puts ""
          puts player_header
          puts @boards[near_side].render(true)
          puts ""
          last_shot = "My" + this_shot[:msg] + "\n\n"
          near_side = (near_side - 1).abs
          far_side = (far_side - 1).abs
          hand_off
        end
      else
        @winner = @players[near_side]
      end
    end

    end_game
  end

  def setup
    # Begin board setup
    puts "Do you want to choose your board size?"
    puts "Please enter 'y' or 'n'."
    user_response = gets.chomp
    if user_response == "yes" || user_response == "y"
      puts "Please enter a board size in the form #x#"
      puts "You may also enter 'default' or 'd' to play with a 10x10 board."
      size = gets.chomp
      if size == "default" || size == "d"
        @boards << Board.new(10, 10)
        @boards << Board.new(10, 10)
      else
        while @boards.length == 0
          dimensions = size.match(/^([0-9]+)[xX]([0-9]+)$/)
          if dimensions.captures.length == 2
            x = dimensions[1].to_i
            y = dimensions[2].to_i
            if x > 3 && y > 3 && x + y >= 8
              @boards << Board.new(x, y)
              @boards << Board.new(x, y)
            end
          end
          if @boards.length == 0
            puts "Those dimensions were invalid. Please try again."
            puts "You may also enter 'default' or 'd' to play with a 10x10 board."
            size = gets.chomp
          end
        end
      end
    else
      @boards << Board.new
      @boards << Board.new
    end
    # End board setup
    system "clear && printf '\e[3J'"
    # Begin player setup
    @players << Player.new(@boards[0], @boards[1])
    ships = []
    puts "Would you like to create your own ships?"
    puts "Please enter 'y' or 'n'."
    user_response = gets.chomp
    if user_response == "yes" || user_response == "y"
      ships = @players[0].get_ships
    else
      ships = @players[0].generate_ships
    end
    system "clear && printf '\e[3J'"
    opponent_ships = ships.map{|ship| ship.clone}
    if @computer_opponent
      @players << Computer.new(@boards[1], @boards[0])
      @players[1].place_ships(opponent_ships)
      @players[0].place_ships(ships)
    else
      @players[0].place_ships(ships)
      puts ""
      puts @boards[0].render(true)
      hand_off
      @players << Player.new(@boards[1], @boards[0])
      @players[1].place_ships(opponent_ships)
      puts ""
      puts @boards[1].render(true)
      hand_off
    end
    # End player setup
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
    system "clear && printf '\e[3J'"

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
    @computer_opponent = true
    start
  end

  def hand_off
    puts "Please press Return when you are ready, then pass the computer to your opponent."
    gets
    system "clear && printf '\e[3J'"
    puts "Please press Return when you are ready to begin your turn."
    gets
  end

  def pad_center(string, target_length)
    missing_chars = [target_length - string.length, 0].max
    left = (missing_chars / 2.0).floor
    right = (missing_chars / 2.0).ceil
    return ("=" * left) + string + ("=" * right)
  end
end
