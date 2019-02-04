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
    # ships array should change, and number of !empty? cells
    # should be equal to the number of spaces it was placing
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
    # ships array should change, and number of !empty? cells
    # should be equal to the number of spaces it was placing
    assert_equal 5, response.length

    assert_equal 17, spaces_with_ships
  end
end
