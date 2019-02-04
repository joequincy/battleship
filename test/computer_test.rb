require './test/test_helper'

class ComputerTest < Minitest::Test
  def setup
    @computer = Computer.new(Board.new, Board.new)
    @ships = [
      Ship.new("Cruiser", 3),
      Ship.new("Submarine", 2)
    ]
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end

  def test_computer_can_place_ships_on_basic_board
    response, board = @computer.place_ships(@ships)
    spaces_with_ships = board.cells.count do |key,cell|
      cell.empty? == false
    end
    assert_equal 2, response.length

    assert_equal 5, spaces_with_ships
  end

  def test_computer_can_place_ships_on_large_board
    ships = [
      Ship.new("Aircraft Carrier", 5),
      Ship.new("Battleship", 4),
      Ship.new("Cruiser", 3),
      Ship.new("Submarine", 3),
      Ship.new("Destroyer", 2)
    ]
    computer = Computer.new(Board.new(10, 10), Board.new(10, 10))
    response, board = computer.place_ships(ships)
    spaces_with_ships = board.cells.count do |key,cell|
      cell.empty? == false
    end
    assert_equal 5, response.length

    assert_equal 17, spaces_with_ships
  end

  def test_computer_can_limit_starting_coords
    default_board = ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]
    limited_coords_3 = @computer.limit_coords(default_board, 3)
    limited_coords_2 = @computer.limit_coords(default_board, 2)
    assert_equal ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "D1", "D2"], limited_coords_3

    assert_equal ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3"], limited_coords_2
  end

  def test_computer_can_get_consecutive_coords
    result = @computer.get_consecutive_coords("A2", 3)
    assert_equal ["A2", "A3", "A4"], result[:horizontal]

    assert_equal ["A2", "B2", "C2"], result[:vertical]
  end

  def test_computer_can_take_shot
    message = @computer.take_shot
    # not really sure how to test this. Nothing should be exposed as
    # an attr_reader, and I want to pass back a message and some
    # attributes to give feedback to the player.
    refute message[:sunk]
    assert_nil message[:ship]
  end
end
