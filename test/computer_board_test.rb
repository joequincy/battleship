require './test/test_helper'

class ComputerBoardTest < Minitest::Test
  def setup
    @board = ComputerBoard.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @cell_1 = @board.cells["A1"]
    @cell_2 = @board.cells["A2"]
    @cell_3 = @board.cells["A3"]
  end

  def test_board_exists
    assert_instance_of ComputerBoard, @board
  end

  def test_board_gets_neighbors_from_central_cell
    expectation = [
      @board.cells["A2"],
      @board.cells["C2"],
      @board.cells["B1"],
      @board.cells["B3"]
    ]
    assert_equal expectation, @board.get_all_neighbors("B2")
  end

  def test_board_gets_neighbors_from_corner_cell
    expectation = [
      @board.cells["B1"],
      @board.cells["A2"]
    ]
    assert_equal expectation, @board.get_all_neighbors("A1")
  end

  def test_board_gets_neighbors_from_edge_cell
    expectation = [
      @board.cells["A1"],
      @board.cells["C1"],
      @board.cells["B2"]
    ]
    assert_equal expectation, @board.get_all_neighbors("B1")
  end

  def test_board_gets_neighbors_without_including_placed_ships
    @board.place(@cruiser, ["B1", "B2", "B3"])
    expectation = [
      @board.cells["A2"]
    ]
    assert_equal expectation, @board.get_all_neighbors("A1")
  end

  def test_board_can_shade_nearby_cells
    @board.place(@cruiser, ["B1", "B2", "B3"])
    expectation = [
      2, 1, 2, 0,
      3, 3, 3, 2,
      2, 1, 2, 0,
      0, 0, 0, 0
    ]
    result = @board.cells.map do |key, cell|
      cell.shade
    end
    assert_equal expectation, result
  end
end
