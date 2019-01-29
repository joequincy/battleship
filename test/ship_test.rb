require './test/test_helper'

class ShipTest < Minitest::Test
  def setup
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Ship, @cruiser
  end

  def test_if_new_ship_is_not_sunk
    refute @cruiser.sunk?
  end

  def test_ship_responds_to_hit

    assert_equal 3, @cruiser.health

    @cruiser.hit
    assert_equal 2, @cruiser.health
  end

  def test_ship_can_sink
    @cruiser.hit
    @cruiser.hit
    @cruiser.hit
    assert @cruiser.sunk?
  end
end
