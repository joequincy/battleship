require './test/test_helper'

class CellTest < Minitest::Test
  def setup
    @cell = Cell.new("B4")
  end
  def test_cell_exists
    assert_instance_of Cell, @cell
  end
  def test_cell_default_attributes
    assert_equal "B4", @cell.coordinate
    assert_nil @cell.ship
  end
end
