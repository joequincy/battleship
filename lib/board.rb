require './lib/cell'

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
        # binding.pry
        if validate_coordinate?(coordinates[index]) &&
           @cells[coordinates[index]].empty?
          # binding.pry
          # Current coordinate is on the board, and doesn't
          # yet have a ship to collide with. Hooray!

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
            step_delta_horizontal = current_column - previous_column
            # binding.pry
            if step_delta_horizontal > 1 || step_delta_horizontal < -1
              # We've moved too far in a single step.
              return false
            end
            delta_horizontal += step_delta_horizontal

            current_row = coordinates[index].match(/^[A-Z]+/)[0].ord
            previous_row = coordinates[index - 1].match(/^[A-Z]+/)[0].ord
            step_delta_vertical = current_row - previous_row
            # binding.pry
            if step_delta_vertical > 1 || step_delta_vertical < -1
              return false
            end
            delta_vertical += step_delta_vertical
            if !(step_delta_horizontal == 0 || step_delta_vertical == 0)
              return false
            end
          end
        else
          # The current cell has a ship in it.
          return false
        end
      end

      if delta_horizontal + delta_vertical == ship.length - 1
        # (delta_horizontal + delta_vertical).abs = ship.length - 1
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
      true
    else
      false
    end
  end

  def fire_upon(coordinate)
    if validate_coordinate?(coordinate) && !@cells[coordinate].fired_upon?
      @cells[coordinate].fire_upon
      true
    else
      false
    end
  end

  def render(show_all_ships = false)
    output = ""
    columns = []
    rows = []

    @cells.keys.each do |coordinate|
      # Cell coordinates consist of an alphabetic row,
      # followed by a numeric column, so use regex to
      # get arrays of each.
      current_column = coordinate.match(/[0-9]+$/)[0].to_i
      columns << current_column if !columns.include?(current_column)
      current_row = coordinate.match(/^[A-Z]+/)[0]
      rows << current_row if !rows.include?(current_row)
    end

    columns.sort!
    rows.sort! do |a,b|
      # If we have more than 26 rows, we're going to start
      # having columns named "AA", "AB", etc. Since the
      # default sort for an array of Strings is alphabetic,
      # that would sort to "A", "AA", "AB", "B", etc. so we
      # need to make sure that when two strings are of
      # differing lengths, we should demote the longer string
      # before even thinking about its alphabetic content.
      if a.length > b.length
        1
      elsif a.length < b.length
        -1
      else
        # Strings are of equal length, so use default sorting.
        a <=> b
      end
    end

    largest_row_address = rows.last
    largest_column_address = columns.last

    output += " " * (largest_row_address.length + 1)
    columns.each do |column|
      output += pad_left(column.to_s, largest_column_address.to_s.length) + " "
    end
    output += "\n"


    rows.each do |row|
      output += pad_left(row, largest_row_address.length) + " "
      columns.each do |column|
        coordinate = row + column.to_s
        cell_render_output = @cells[coordinate].render(show_all_ships)
        output += pad_left(cell_render_output, largest_column_address.to_s.length) + " "
      end
      output += "\n"
    end
    return output
  end

  def pad_left(string, total_length_needed)
    return_string = " " * (total_length_needed - string.length)
    return_string += string
  end

  def all_ships_sunk?
    @cells.none? do |key, cell|
      if cell.empty? == false && cell.fired_upon? == false
        true
      end
    end
  end
end
