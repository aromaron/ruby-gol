# RULES

# 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
# 2. Any live cell with two or three live neighbours lives on to the next generation.
# 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
# 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.


class Grid
  attr_accessor :universe

  def initialize(universe = Universe.new)
    @universe = universe

    # need to insert the living cells into the grid
    populate_grid
  end

  def tick!

    # first approach was to die/live each cell once the rule was applied
    # but i think it can be overwriten on each tick
    # so after all the rules are checked i'll set all the cells to die and all the cells to live
    # onto the next generation
    cells_to_die = []
    cells_to_live = []

    universe.cells.each do |cell|

      # Any live cell with fewer than two live neighbours dies
      if cell.alive? && self.universe.live_neighbours(cell).count < 2
        cells_to_die << cell
      end

      # Any live cell with two or three live neighbours lives
      if cell.alive? && [2, 3].include?(self.universe.live_neighbours(cell).count)
        cells_to_live << cell
      end

      # Any live cell with more than three live neighbours dies
      if cell.alive? && self.universe.live_neighbours(cell).count > 3
        cells_to_die << cell
      end

      # Any dead cell with exactly three live neighbours becomes a live cell
      if cell.dead? && self.universe.live_neighbours(cell).count == 3
        cells_to_live << cell
      end
    end

    cells_to_live.map {|cell| cell.live! }
    cells_to_die.map {|cell| cell.die! }
  end

  private

  def populate_grid
    universe.cells.each do |cell|
      universe.grid[cell.y][cell.x] = cell if cell.alive?
    end
  end
end


#    x - horizontal/columns
#    y - vertical/rows
#
#      0 1 2 3 4
#    0
#    1
#    2
#    3
#    4

class Universe
  attr_accessor :rows, :cols, :cells, :grid

  def initialize(rows = 3, cols = 3)
    # Needed to add a way to relate the cells that belongs to the universe
    @cells = []

    # Needed to add a way to position the cells within a grid to be able to move around
    # it and compare
    @rows = rows
    @cols = cols
    @grid = build_grid
  end

  def live_neighbours(cell)
    neighbours = []

    # Checks for neighbours given a cell coordinates

    # It has live neighbours at the TOP
    # Do not check for top neighbours if is the first row
    if cell.y > 0
      neighbour = self.grid[cell.y - 1][cell.x]
      neighbours << neighbour if neighbour.alive?
    end

    # It has live neighbours at the TOP LEFT
    # Do not check for top neighbours if is the first row
    # Do not check for left neighbours if is the first column
    if cell.y > 0 && cell.x > 0
      neighbour = self.grid[cell.y - 1][cell.x - 1]
      neighbours << neighbour if neighbour.alive?
    end

    # It has live neighbours at the TOP RIGHT
    # Do not check for top neighbours if is the first row
    # Do not check for right neighbours if is the last column
    if cell.y > 0 && cell.x < cols - 1
      # check in the grid for a live neighbour at the top of the curren cell coorinates
      neighbour = self.grid[cell.y - 1][cell.x + 1]
      neighbours << neighbour if neighbour.alive?
    end


    # It has live neighbours at the LEFT
    # Do not check for left neighbours if is the first column
    if cell.x > 0
      # check in the grid for a live neighbour at the top of the curren cell coorinates
      neighbour = self.grid[cell.y][cell.x - 1]
      neighbours << neighbour if neighbour.alive?
    end

    # It has live neighbours at the RIGHT
    # Do not check for right neighbours if is the last column
    if cell.x < cols - 1
      # check in the grid for a live neighbour at the top of the curren cell coorinates
      neighbour = self.grid[cell.y][cell.x + 1]
      neighbours << neighbour if neighbour.alive?
    end

    # It has live neighbours at the BOTTOM
    # Do not check for bottom neighbours if is the last row
    if cell.y < rows - 1
      # check in the grid for a live neighbour at the top of the curren cell coorinates
      neighbour = self.grid[cell.y + 1][cell.x]
      neighbours << neighbour if neighbour.alive?
    end

    # It has live neighbours at the BOTTOM LEFT
    # Do not check for bottom neighbours if is the last row
    # Do not check for left neighbours if is the first column
    if cell.y < rows - 1 && cell.x > 0
      neighbour = self.grid[cell.y + 1][cell.x - 1]
      neighbours << neighbour if neighbour.alive?
    end

    # It has live neighbours at the BOTTOM RIGHT
    # Do not check for bottom neighbours if is the last row
    # Do not check for right neighbours if is the last column
    if cell.y < rows - 1 && cell.x < cols - 1
      neighbour = self.grid[cell.y + 1][cell.x + 1]
      neighbours << neighbour if neighbour.alive?
    end


    neighbours
  end

  private

  def build_grid
    # This will need to be an Array of rows and an Array of cols
    # Probably will start the initial grid with all dead Cells
    Array.new(rows) do |row|
      Array.new(cols) do |col|
        Cell.new(col, row, self, 0)
      end
    end
  end
end


class Cell
  attr_accessor :x, :y, :universe, :state

  # In order to know if it has neighbours at a given positiong
  # I need to know the cell currents coordinates.
  # I thougt of adding here a method live_neighbours but I think makes more sense
  # In a Universe object so I can compare a Cell with the Neighbours in the Universe

  def initialize(x = 1, y = 1, universe = Universe.new, state = 1)
    @x = x
    @y = y
    @state = state

    # Needed to add a way to relate the cells that belongs to the universe
    @universe = universe
    @universe.cells << self
  end

  # I know I can negate the following statements using (!) but for the sake of the excersice
  # decided to use a more explicit way
  def alive?
    self.state == 1
  end

  def dead?
    self.state == 0
  end

  def die!
    self.state = 0
  end

  def live!
    self.state = 1
  end
end
