class Board
  attr_reader :cells
  def initialize
    @cells = {
      "A1" => Cell.new("A1"),
      "A2" => Cell.new("A2"),
      "A3" => Cell.new("A3"),
      "A4" => Cell.new("A4"),
      "B1" => Cell.new("B1"),
      "B2" => Cell.new("B2"),
      "B3" => Cell.new("B3"),
      "B4" => Cell.new("B4"),
      "C1" => Cell.new("C1"),
      "C2" => Cell.new("C2"),
      "C3" => Cell.new("C3"),
      "C4" => Cell.new("C4"),
      "D1" => Cell.new("D1"),
      "D2" => Cell.new("D2"),
      "D3" => Cell.new("D3"),
      "D4" => Cell.new("D4")
    }
  end

  def validate_coordinate?(coordinate)
    @cells.keys.include?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    if coordinates.length == ship.length
      # Right number of cells for this ship
      delta_horizontal = 0
      delta_vertical = 0
      coordinates.each_index do |index|
        if @cells[coordinates[index]].empty?
          # For every element in the array of coordinates
          # determine the delta (change in value) from the
          # previous element (skip the first array element).
          # A successful ship placement will only have delta
          # in either the horizontal or vertical direction
          # (not both), and the total delta will be 1 less
          # than the length of the ship.
          if index > 0
            current_column = coordinates[index].match(/[0-9]+$/)[0].to_i
            previous_column = coordinates[index - 1].match(/[0-9]+$/)[0].to_i
            temp_delta_horizontal = current_column - previous_column
            if temp_delta_horizontal <= 1 && temp_delta_horizontal >= -1
              delta_horizontal += temp_delta_horizontal
            else
              return false
            end

            current_row = coordinates[index].match(/^[A-Z]+/)[0].ord
            previous_row = coordinates[index - 1].match(/^[A-Z]+/)[0].ord
            temp_delta_vertical = current_row - previous_row
            if temp_delta_vertical <= 1 && temp_delta_vertical >= -1
              delta_vertical += temp_delta_vertical
            else
              return false
            end
          end
        else
          # The current cell has a ship in it.
          return false
        end
      end
      if (delta_horizontal == 0 || delta_vertical == 0) && (delta_horizontal + delta_vertical == ship.length - 1)
        # (delta_horizontal + delta_vertical).abs = ship.lenth - 1
        # would allow this to function even if ships
        # are placed in reverse direction
        true
      else
        false
      end
    else
      # Wrong number of cells for ship
      false
    end
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    else
      # warn player that this position was invalid
    end
  end

  def render(show_all_ships = false)
    output = ""
    columns = []
    rows = []

    @cells.keys.each do |coordinate|
      current_column = coordinate.match(/[0-9]+$/)[0].to_i
      columns << current_column if !columns.include?(current_column)
      current_row = coordinate.match(/^[A-Z]+/)[0]
      rows << current_row if !rows.include?(current_row)
    end

    columns.sort!
    rows.sort! do |a,b|
      if a.length > b.length
        1
      elsif a.length < b.length
        -1
      else
        a <=> b
      end
    end

    left_side_width = rows.sort{|a,b| b.length <=> a.length}.first.length + 1
    output += "#{" " * left_side_width}#{columns.join(" ")} \n"

    rows.each do |row|
      output += " " * (left_side_width - row.length - 1)
      output += row + " "
      columns.each do |column|
        output += @cells[row + column.to_s].render(show_all_ships) + " "
      end
      output += "\n"
    end
    return output
  end
end
