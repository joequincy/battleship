class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @fired_upon = true
    @ship.hit if @ship
  end

  def render(debug = false)
    if !fired_upon?
      if @ship
        if debug
          "S"
        else
          "."
        end
      else
        "."
      end
    else
      if @ship
        if @ship.sunk?
          "X"
        else
          "H"
        end
      else
        "M"
      end
    end
  end
end
