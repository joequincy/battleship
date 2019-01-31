require './lib/ship'

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

  def render(show_all_ships = false)
    if fired_upon? && @ship
      if @ship.sunk?
        "X"
      else
        "H"
      end
    elsif fired_upon?
      "M"
    elsif @ship && show_all_ships
      "S"
    else
      "."
    end
  end
end
