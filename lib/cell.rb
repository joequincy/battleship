require './lib/ship'

class Cell
  attr_reader :coordinate, :ship

  @@colorize = (ARGV.length > 0 && ARGV[0] == "--color") ? true : false
  ## if we start the runner with a --color switch, render in color.

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
    @colorize = @@colorize
  end

  def colorize=(bool)
    @colorize = bool
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
    if @colorize == true
      if fired_upon? && @ship
        if @ship.sunk?
          "\e[38;5;88m\u2588\e[0m"
        else
          "\e[38;5;196m\u2588\e[0m"
        end
      elsif fired_upon?
        "\e[38;5;123m\u2588\e[0m"
      elsif @ship && show_all_ships
        "\e[38;5;240m\u2588\e[0m"
      else
        "\e[38;5;27m\u2588\e[0m"
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
