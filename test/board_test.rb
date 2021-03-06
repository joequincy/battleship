require './test/test_helper'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @cell_1 = @board.cells["A1"]
    @cell_2 = @board.cells["A2"]
    @cell_3 = @board.cells["A3"]
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

  def test_board_validates_whether_coordinates_are_on_board
    assert @board.validate_coordinate?("A1")

    assert @board.validate_coordinate?("D4")

    refute @board.validate_coordinate?("A5")

    refute @board.validate_coordinate?("E1")

    refute @board.validate_coordinate?("A22")
  end

  def test_board_accepts_valid_placements
    assert @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])

    assert @board.valid_placement?(@submarine, ["A1", "A2"])

    assert @board.valid_placement?(@cruiser, ["A1", "B1", "C1"])

    assert @board.valid_placement?(@submarine, ["D3", "D4"])
  end

  def test_board_rejects_ship_placement_of_invalid_length
    refute @board.valid_placement?(@cruiser, ["A1", "A2"])

    refute @board.valid_placement?(@submarine, ["A1", "A2", "A3"])
  end

  def test_board_rejects_non_consecutive_coordinates
    refute @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])

    refute @board.valid_placement?(@cruiser, ["A1", "A4", "A3"])

    refute @board.valid_placement?(@submarine, ["A1", "C1"])

    refute @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])

    refute @board.valid_placement?(@submarine, ["C1", "B1"])

    refute @board.valid_placement?(@cruiser, ["A1", "B2", "C1"])
  end

  def test_board_rejects_diagonal_coordinates
    refute @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])

    refute @board.valid_placement?(@submarine, ["C2", "D3"])
  end

  def test_board_can_place_ship
    @board.place(@cruiser, ["A1", "A2", "A3"])
    assert_equal @cruiser, @cell_1.ship

    assert_equal @cell_1.ship, @cell_2.ship
  end

  def test_board_rejects_overlapping_ships
    @board.place(@cruiser, ["A1", "A2", "A3"])
    refute @board.valid_placement?(@submarine, ["A1", "B1"])
  end

  def test_board_render_output
    @board.place(@cruiser, ["A1", "A2", "A3"])
    expectation = "  1 2 3 4 \n" +
                  "A S S S . \n" +
                  "B . . . . \n" +
                  "C . . . . \n" +
                  "D . . . . \n"
    assert_equal expectation, @board.render(true)

    assert_equal expectation.gsub("S","."), @board.render
  end

  def test_board_can_fire_on_cells
    @board.place(@submarine, ["A1", "A2"])
    @board.fire_upon("A1")
    assert_equal 1, @submarine.health

    @board.fire_upon("A2")
    assert @submarine.sunk?
  end

  def test_board_will_not_fire_on_empty_cells_that_were_already_fired_upon
    unfired_cell = @board.fire_upon("A1")
    assert_instance_of String, unfired_cell[:outcome]

    already_fired_cell = @board.fire_upon("A1")
    assert_nil already_fired_cell[:outcome]
  end

  def test_board_will_not_fire_on_full_cells_that_were_already_fired_upon
    @board.place(Ship.new("Cruiser", 3), ["A1", "A2", "A3"])
    unfired_cell = @board.fire_upon("A1")
    assert_instance_of String, unfired_cell[:outcome]

    already_fired_cell = @board.fire_upon("A1")
    assert_nil already_fired_cell[:outcome]
  end

  def test_board_renders_midgame_output
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["C1", "D1"])
    @board.fire_upon("A1")
    @board.fire_upon("B4")
    @board.fire_upon("C1")
    @board.fire_upon("D1")
    expectation = "  1 2 3 4 \n" +
                  "A H S S . \n" +
                  "B . . . M \n" +
                  "C X . . . \n" +
                  "D X . . . \n"
    assert_equal expectation, @board.render(true)

    assert_equal expectation.gsub("S","."), @board.render
  end

  def test_board_pads_left_side_of_strings
    assert_equal " test", @board.pad_left("test", 5)
  end

  def test_board_can_determine_if_all_ships_are_sunk
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["C1", "D1"])
    assert_equal false, @board.all_ships_sunk?

    @board.fire_upon("A1")
    @board.fire_upon("A2")
    @board.fire_upon("A3")
    @board.fire_upon("C1")
    @board.fire_upon("D1")
    assert_equal true, @board.all_ships_sunk?
  end
end
