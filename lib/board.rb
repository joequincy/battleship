require './lib/cell'

class Board
  attr_reader :cells,
              :width,
              :height
  def initialize(width = 4, height = 4)
    @width = width
    @height = height
    @cells = generate_board_cells
  end

  def generate_board_cells
    cells = Hash.new do |hash,key|
      hash[key] = Cell.new(key)
    end
    (1..@height).each do |row|
      (1..@width).each do |column|
        cells[row.to_row_letters + column.to_s]
      end
    end
    return cells
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
            current_address = coordinates[index].split_coordinate
            previous_address = coordinates[index - 1].split_coordinate
            current_column = current_address[:column]
            previous_column = previous_address[:column]
            step_delta_horizontal = current_column - previous_column
            # binding.pry
            if step_delta_horizontal > 1 || step_delta_horizontal < -1
              # We've moved too far in a single step.
              return {pass: false,
                       msg: "#{coordinates[index]} is too far from #{coordinates[index - 1]}"}
            end
            delta_horizontal += step_delta_horizontal

            current_row = current_address[:row].to_row_num
            previous_row = previous_address[:row].to_row_num
            step_delta_vertical = current_row - previous_row
            # binding.pry
            if step_delta_vertical > 1 || step_delta_vertical < -1
              return {pass: false,
                       msg: "#{coordinates[index]} is too far from #{coordinates[index - 1]}"}
            end
            delta_vertical += step_delta_vertical
            if !(step_delta_horizontal == 0 || step_delta_vertical == 0)
              return {pass: false,
                       msg: "#{coordinates[index]} is diagonal from #{coordinates[index - 1]}"}
            end
          end
        else
          # The current cell has a ship in it or isn't on the board.
          output = {pass: false}
          if validate_coordinate?(coordinates[index])
            output[:msg] = "There's already a ship in #{coordinates[index]}"
          else
            output[:msg] = "#{coordinates[index]} isn't on the board"
          end
          return output
        end
      end

      if (delta_horizontal == 0 || delta_vertical == 0) &&
         delta_horizontal + delta_vertical == ship.length - 1
        # (delta_horizontal + delta_vertical).abs = ship.length - 1
        # would allow this to function even if ships
        # are placed in reverse direction
        return {pass: true}
      else
        return {pass: false,
                 msg: "Those coordinates aren't shaped like #{ship.name}"}
      end
    else
      # Wrong number of cells for ship
      return {pass: false,
               msg: "The #{ship.name} is #{ship.length} cells long, but you gave #{coordinates.length} cells"}
    end
  end

  def place(ship, coordinates)
    test = valid_placement?(ship, coordinates)
    if test[:pass]
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    end
    return test
  end

  def fire_upon(coordinate)
    # puts "Board.fire_upon(coordinate) received coordinate of class #{coordinate.class}."
    cell = @cells[coordinate]
    is_valid = validate_coordinate?(coordinate)
    fired_upon = cell.fired_upon?
    if is_valid && !fired_upon
      cell.fire_upon
      if cell.empty?
        return {
           msg: "miss",
          sunk: false,
          ship: nil
        }
      else
        if cell.ship.sunk?
          return {
             msg: "hit",
            sunk: true,
            ship: cell.ship.name
          }
        else
          return {
             msg: "hit",
            sunk: false,
            ship: nil
          }
        end
      end
    elsif fired_upon
      "That coordinate has already been fired upon."
    else
      "That coordinate is not on the board."
    end
  end

  def render(show_all_ships = false)
    output = ""
    columns = []
    rows = []

    # p @cells
    # p @cells.keys

    @cells.keys.each do |coordinate|
      # puts "Coordinate: "
      # p coordinate
      address = coordinate.split_coordinate
      columns << address[:column] if !columns.include?(address[:column])
      rows << address[:row] if !rows.include?(address[:row])
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
        target_length = cell_render_output.length + largest_column_address.to_s.length - 1
        output += pad_left(cell_render_output, target_length) + " "
      end
      output += "\n"
    end
    return output
  end

  def pad_left(string, total_length_needed)
    return_string = " " * (total_length_needed - string.length)
    return_string += string
  end
end
