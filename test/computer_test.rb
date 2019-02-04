require './test/test_helper'

class ComputerTest < Minitest::Test
  def setup
    @computer = Computer.new(Board.new, Board.new)
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end
end
