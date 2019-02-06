require './lib/converters'
require './lib/computer_board'
require './lib/computer_cell'

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
    @ships = ships.map{|ship| ship.dup}
    ships = @ships.dup
    empty_coords = @own_board.cells.keys
    while ships.length > 0
      current_ship = ships.shift
      tightness = @intelligence
      potential_coords = limit_coords(empty_coords, current_ship.length, tightness)
      validation = {pass: false}
      position = []
      begin
        direction = rand(2)
        starting_coord = ""
        if direction == 0
          starting_coord = potential_coords[:h].sample
          potential_coords[:h].delete(starting_coord)
        else
          starting_coord = potential_coords[:v].sample
          potential_coords[:v].delete(starting_coord)
        end
        position = get_consecutive_coords(starting_coord, current_ship.length, direction)
        validation = @own_board.place(current_ship, position)
        if !validation[:pass] && potential_coords[:h].length == 0 && potential_coords[:v].length == 0
          tightness -= 1
          potential_coords = limit_coords(empty_coords, current_ship.length, tightness)
        end
      end until validation[:pass]
      position.each do |coord|
        empty_coords.delete(coord)
      end
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

  def get_consecutive_coords(starting_coord, length, direction)
    result_coords = []
    address = starting_coord.split_coordinate
    starting_row_num = address[:row].to_row_num
    rows = []
    columns = []
    (1..length).each do |i|
      rows << (starting_row_num + i - 1).to_row_letters
      columns << address[:column] + i - 1
    end
    if direction == 1
      rows.each do |row|
        result_coords << row + address[:column].to_s
      end
    else
      columns.each do |column|
        result_coords << address[:row] + column.to_s
      end
    end
    return result_coords
  end

  def limit_coords(empty_coords, length, tightness)
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
    output = {h: [], v: []}
    rows.each_index do |row|
      columns.each_index do |column|
        if row <= max_row - length
          coord = (rows[row] + columns[column].to_s)
          if (tightness > 0 && open_ahead?(coord, :v, length, tightness)) || tightness == 0
            output[:v] << coord
          end
        end
        if column <= max_col - length
          coord = (rows[row] + columns[column].to_s)
          if (tightness > 0 && open_ahead?(coord, :h, length, tightness)) || tightness == 0
            output[:h] << coord
          end
        end
      end
    end
    return output
  end

  def open_ahead?(coord, direction, length, tightness)
    address = coord.split_coordinate
    (2..length).none? do |i|
      i -= 1
      new_coord = ""
      if direction == :v
        row = (address[:row].to_row_num + i).to_row_letters
        new_coord = row + address[:column].to_s
      elsif direction == :h
        column = address[:column] + i
        new_coord = address[:row] + column.to_s
      end
      if @own_board.validate_coordinate?(new_coord)
        @own_board.cells[new_coord].shade > tightness
      else
        false
      end
    end
  end

  def pretty_print_coordinates(coordinates)
    h = coordinates.group_by do |coordinate|
      coordinate.match(/^[A-Z]+/)[0]
    end
    puts "["
    h.each_value do |arr|
      arr.each do |elm|
        print elm + ", "
      end
      print "\n"
    end
    puts "]"
  end
end
