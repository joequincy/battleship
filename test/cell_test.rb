require './test/test_helper'

class CellTest < Minitest::Test
  def setup
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end
  def test_cell_exists
    assert_instance_of Cell, @cell
  end
  def test_cell_default_attributes
    assert_equal "B4", @cell.coordinate
    assert_nil @cell.ship
  end
  def test_cell_is_empty_by_default
    assert @cell.empty?
  end
  def test_cell_can_place_ship
    @cell.place_ship(@cruiser)
    assert_equal @cruiser, @cell.ship
  end
  def test_cell_not_empty_if_ship_is_placed
    @cell.place_ship(@cruiser)
    refute @cell.empty?
  end
  
end
