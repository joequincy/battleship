require './lib/board'
require './lib/computer_cell'
require './lib/converters'

class ComputerBoard < Board
  def initialize(width = 4, height = 4)
    super(width, height)
    @cells = generate_board_cells
  end

  def generate_board_cells
    cells = Hash.new do |hash,key|
      hash[key] = ComputerCell.new(key)
    end
    (1..@height).each do |row|
      (1..@width).each do |column|
        cells[row.to_row_letters + column.to_s]
      end
    end
    return cells
  end

  def place(ship, coordinates)
    test = super(ship, coordinates)
    if test[:pass]
      shade_nearby_cells(coordinates)
    end
    return test
  end

  def shade_nearby_cells(coordinates)
    coordinates.each_with_index do |coordinate, i|
      get_all_neighbors(coordinate).each do |cell|
        if i == 0 || i == coordinates.length - 1
          cell.shade = 2
        else
          cell.shade = [cell.shade + 1, 3].min
        end
      end
      @cells[coordinate].shade = 3
    end
  end

  def get_all_neighbors(coordinate)
    neighbors = []
    address = coordinate.split_coordinate
    row = address[:row].to_row_num
    column = address[:column]
    rows = [row - 1, row + 1]
    columns = [column - 1, column + 1]
    neighbor_addresses = []
    rows.each do |row|
      neighbor_addresses << row.to_row_letters + address[:column].to_s
    end
    columns.each do |column|
      neighbor_addresses << address[:row] + column.to_s
    end
    neighbor_addresses.each do |address|
      if validate_coordinate?(address) && @cells[address].empty?
        neighbors << @cells[address]
      end
    end
    return neighbors
  end
end
