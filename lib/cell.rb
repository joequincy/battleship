require './lib/ship'

class Cell
  attr_reader :coordinate, :ship

  @@colorize = (ARGV.length > 0 && ARGV[0] == "--color") ? true : false
  ## if we start the runner with a --color switch, render in color.

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def colorize=(bool)
    if bool == true || bool == false
      @@colorize = bool
    end
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
    if @@colorize
      if fired_upon? && @ship
        if @ship.sunk?
          "\e[90mX\e[0m"
        else
          "\e[31mH\e[0m"
        end
      elsif fired_upon?
        "\e[93mM\e[0m"
      elsif @ship && show_all_ships
        "S"
      else
        "\e[36m\u2592\e[0m"
      end
    else
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
end

ARGV.clear
