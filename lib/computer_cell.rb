require './lib/cell'

class ComputerCell < Cell
  attr_accessor :shade

  def initialize(coordinate)
    super(coordinate)
    @shade = 0
  end

  def render(show_all_ships = false, debug = false)
    output = super(show_all_ships)
    if debug && shade > 0
      color = "\e[38;5;45m"
      if shade == 1
        color = "\e[93m"
      elsif shade == 2
        color = "\e[38;5;208m"
      elsif shade == 3
        color = "\e[38;5;196m"
      end
      output.sub("\e[38;5;45m",color)
    end
    output
  end
end
