require './test/test_helper'

class PlayerTest < Minitest::Test
  def setup
    @player = Player.new
  end
  def test_player_exists
    assert_instance_of Player, @player
  end
end
