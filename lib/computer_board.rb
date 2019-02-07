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
          cell.shade = [cell.shade + 2, 3].min
        else
          cell.shade = [cell.shade + 1, 3].min
        end
      end
      @cells[coordinate].shade = 3
    end
  end
end
