require './test/test_helper'


class ComputerTest < Minitest::Test

  def test_it_exists
    computer = Computer.new(Board.new, Board.new)
    assert_instance_of Computer, computer
  end

  def test_that_computer_can_place_ships
    computer = Computer.new(Board.new, Board.new)
    ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
    computer.place_ships(ships)
    assert_equal 2, computer.ships.length

    spaces_with_ships = computer.own_board.cells.count do |key, cell|
      cell.empty? == false
    end
    assert_equal 5, spaces_with_ships
  end

  def test_computer_can_take_a_shot
    computer = Computer.new(Board.new, Board.new)
    computer.take_shot
    cells_fired_upon = computer.enemy_board.cells.count do |key, cell|
      cell.fired_upon? == true
    end
    assert_equal 1, cells_fired_upon
  end

  def test_computer_can_tell_it_won
    player_board = Board.new
    computer_board = Board.new
    computer = Computer.new(computer_board, player_board)
    test_computer_ship = Ship.new("Submarine", 2)
    test_player_ship = Ship.new("Submarine", 2)

    computer_board.place(test_computer_ship, ["A1", "A2"])
    player_board.place(test_player_ship, ["A1", "A2"])

    player_board.fire_upon("A1")
    assert_equal false, computer.check_for_winner

    player_board.fire_upon("A2")
    assert_equal true, computer.check_for_winner
  end
end
