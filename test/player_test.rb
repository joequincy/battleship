require './test/test_helper'

class PlayerTest < Minitest::Test
  def setup
    @player = Player.new(Board.new, Board.new)
  end
  def test_player_exists
    assert_instance_of Player, @player
  end

  def test_ship_name_normalization
    bad_ship_name_1 = "sad"
    bad_ship_name_2 = "sad day"
    assert_equal "Sad", @player.normalize_ship_name(bad_ship_name_1)

    assert_equal "Sad Day", @player.normalize_ship_name(bad_ship_name_2)
  end

  def test_player_can_determine_how_many_ship_spaces_there_should_be
    assert_equal 5, @player.get_num_ship_spaces

    player = Player.new(Board.new(10, 10), Board.new(10, 10))
    assert_equal 17, player.get_num_ship_spaces
  end

  def test_player_can_create_set_of_ships
    expectation_5 = [
      Ship.new("Submarine", 3),
      Ship.new("Destroyer", 2)
    ]
    actual_5 = @player.create_ship_set(5)
    assert_equal expectation_5.length, actual_5.length
    assert actual_5.any?{|ship| ship.name == "Submarine"}
    refute actual_5.any?{|ship| ship.name == "Aircraft Carrier"}

    expectation_17 = [
      Ship.new("Aircraft Carrier", 5),
      Ship.new("Battleship", 4),
      Ship.new("Cruiser", 3),
      Ship.new("Submarine", 3),
      Ship.new("Destroyer", 2)
    ]
    actual_17 = @player.create_ship_set(17)
    assert_equal expectation_17.length, actual_17.length
    assert_equal 1, actual_17.count{|ship| ship.name == "Cruiser"}
    assert_equal 1, actual_17.count{|ship| ship.name == "Aircraft Carrier"}
  end

  def test_player_can_generate_ship_presets
    small_ships = @player.generate_ships
    assert_equal 2, small_ships.length
    assert_equal "Cruiser", small_ships.first.name

    player = Player.new(Board.new(10, 10), Board.new(10, 10))
    large_ships = player.generate_ships
    assert_equal 5, large_ships.length
    assert_equal "Aircraft Carrier", large_ships.first.name
  end
end
