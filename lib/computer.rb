require './lib/converters'

class Computer < Player
  def initialize(own_board, enemy_board, intelligence = 0)
    super(own_board, enemy_board)
    @intelligence = intelligence
    @shots = {
      hits: [],
      misses: []
    }
    @untargeted_spaces = enemy_board.cells.keys
    # each item in hit or miss array is an array containing
    # turn sequence (int), cell coordinate (str)
  end

  def place_ships(ships)
    # @ships = ships.map{|ship| ship.clone}
    @ships = ships.clone
    if @intelligence == 0
      empty_coords = @own_board.cells.keys
      while ships.length > 0
        current_ship = ships.shift
        potential_coords = limit_coords(empty_coords, current_ship.length)
        exit_loop = false
        placed_position = []
        begin
          starting_coord = potential_coords.sample
          position = get_consecutive_coords(starting_coord, current_ship.length)
          test_order = rand(2)
          if test_order == 0
            exit_loop = @own_board.place(current_ship, position[:horizontal])
            if !exit_loop
              exit_loop = @own_board.place(current_ship, position[:vertical])
              placed_position = position[:vertical]
            else
              placed_position = position[:horizontal]
            end
          else
            exit_loop = @own_board.place(current_ship, position[:vertical])
            if !exit_loop
              exit_loop = @own_board.place(current_ship, position[:horizontal])
              placed_position = position[:horizontal]
            else
              placed_position = position[:vertical]
            end
          end
          potential_coords.delete(starting_coord)
        end until exit_loop[:pass]
        placed_position.each do |coord|
          empty_coords.delete(coord)
        end
      end
    else
      # be smarter
    end
    return @ships, @own_board
  end

  def take_shot
    # fire a shot according to intelligence level
    if @intelligence == 0
      target = @untargeted_spaces.sample
      @untargeted_spaces.delete(target)
      result = @enemy_board.fire_upon(target)
      return {
         msg: " shot on #{target} was a #{result[:msg]}.",
        sunk: result[:sunk],
        ship: result[:ship]
      }
    end
  end

  def get_consecutive_coords(starting_coord, length)
    result_coords = {
      horizontal: [],
      vertical: []
    }
    address = starting_coord.split_coordinate
    starting_row_num = address[:row].to_row_num
    rows = []
    columns = []
    (1..length).each do |i|
      rows << (starting_row_num + i - 1).to_row_letters
      columns << address[:column] + i - 1
    end
    rows.each do |row|
      result_coords[:vertical] << row + address[:column].to_s
    end
    columns.each do |column|
      result_coords[:horizontal] << address[:row] + column.to_s
    end
    return result_coords
  end

  def limit_coords(empty_coords, length)
    rows = []
    columns = []
    empty_coords.each do |coord|
      address = coord.split_coordinate
      rows << address[:row]
      columns << address[:column]
    end
    rows.uniq!
    columns.uniq!
    max_row = rows.max.to_row_num
    max_col = columns.max
    output = []
    rows.each_index do |row|
      columns.each_index do |column|
        if row < max_row - length + 1 || column < max_col - length + 1
          output << (rows[row] + columns[column].to_s)
        end
      end
    end
    return output
  end
end
