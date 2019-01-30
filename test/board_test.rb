require './test/test_helper'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
  end

  def test_board_exists
    assert_instance_of Board, @board
  end

  def test_board_initializes_with_hash_of_cells
    assert_instance_of Hash, @board.cells
    assert_equal 16, @board.cells.keys.length
    random_key = @board.cells.keys.sample
    assert_instance_of Cell, @board.cells[random_key]
  end

  
end
