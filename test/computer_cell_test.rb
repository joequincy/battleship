require './test/test_helper'

class ComputerCellTest < Minitest::Test
  def setup
    @cell = ComputerCell.new("B4")
  end

  def test_cell_exists
    assert_instance_of ComputerCell, @cell
  end

  def test_cell_shade_initially_zero
    assert_equal 0, @cell.shade
  end

  def test_cell_can_be_shaded
    @cell.shade = 2
    assert_equal 2, @cell.shade
  end
end
