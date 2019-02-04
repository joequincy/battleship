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

  def test_cell_is_not_fired_upon
    refute @cell.fired_upon?
  end

  def test_cell_is_fired_upon
    @cell.fire_upon
    assert @cell.fired_upon?
  end

  def test_cell_affects_ship_when_fired_upon
    @cell.place_ship(@cruiser)
    @cell.fire_upon
    assert_equal 2, @cell.ship.health
  end

  def test_empty_cell_renders_correctly
    assert_equal ".", @cell.render

    @cell.fire_upon
    assert_equal "M", @cell.render
  end

  def test_cell_with_ship_renders_correctly
    @cell.place_ship(@cruiser)
    assert_equal ".", @cell.render

    assert_equal "S", @cell.render(true)

    @cell.fire_upon
    assert_equal "H", @cell.render

    @cruiser.hit
    @cruiser.hit
    assert_equal "X", @cell.render
  end

  def test_colorized_cell_renders_correctly
    empty_cell = Cell.new("B4")
    empty_cell.colorize = true
    ship_cell = Cell.new("B4")
    ship_cell.colorize = true
    assert_equal "\e[36m\u2592\e[0m", empty_cell.render

    empty_cell.fire_upon
    assert_equal "\e[93mM\e[0m", empty_cell.render

    ship_cell.place_ship(@cruiser)
    assert_equal "\e[36m\u2592\e[0m", ship_cell.render

    assert_equal "S", ship_cell.render(true)

    ship_cell.fire_upon
    assert_equal "\e[31mH\e[0m", ship_cell.render

    @cruiser.hit
    @cruiser.hit
    assert_equal "\e[90mX\e[0m", ship_cell.render
  end
end
