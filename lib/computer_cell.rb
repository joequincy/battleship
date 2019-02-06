require './lib/cell'

class ComputerCell < Cell
  attr_accessor :shade

  @@colorize = (ARGV.length > 0 && ARGV[0] == "--color") ? true : false
  ## if we start the runner with a --color switch, render in color.
  def initialize(coordinate)
    super(coordinate)
    @shade = 0
  end
end
