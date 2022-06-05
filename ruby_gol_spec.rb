require 'rspec'
require './ruby_gol.rb'

# RULES

# 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
# 2. Any live cell with two or three live neighbours lives on to the next generation.
# 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
# 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

#  - Need Cell, Live Neighbours, Grid, a Universe.
#  - The Cell is part of a Universe of cells that will interact with each other
#  - The Grid is a matrix that helds the universe
#  - Test the positions of cells neighbours
#    - at the top
#    - at the top left
#    - at the top right
#    - at the left
#    - at the right
#    - at the bottom
#    - at the bottom left
#    - at the bottom right
#   - Test the first rule
#   - Test the second rule
#   - Test the third rule
#   - Test the forth rule

#  On this first iteration Im not going to focus on the graphics or display of the game
#  Instead I choose to make sure I understand fairly well how to apply the rules
#  And how to look for a Cell neighbours, I think if the logic works as expected, then
#  I can extend its functionality and implement a visual output, also, by Using TDD
#  I can make sure I can refactor the code and will continue working as supposed to.

describe 'Game of Life' do
  # Im going to start testing the first rule, most of the logic is centered in the Cells behaviour
  # I think in order to make the first rule pass, any other logic needed, will be developing
  # by the TDD process
  let(:grid) { Grid.new }

  context 'Universe' do
    subject { grid.universe }

    it 'cell has live neighbours at the top' do
      cell       = subject.grid[1][1]
      other_cell = subject.grid[1][0]
      cell.live!
      other_cell.live!

      expect(subject.live_neighbours(cell).count).to eq 1
    end

    it 'cell has live neighbours at the top left' do
      cell       = subject.grid[1][1]
      other_cell = subject.grid[0][0]
      cell.live!
      other_cell.live!

      expect(subject.live_neighbours(cell).count).to eq 1
    end

    it 'cell has live neighbours at the top right' do
      cell       = subject.grid[1][1]
      other_cell = subject.grid[2][0]
      cell.live!
      other_cell.live!

      expect(subject.live_neighbours(cell).count).to eq 1
    end

    it 'cell has live neighbours at the left' do
      cell       = subject.grid[1][1]
      other_cell = subject.grid[0][1]
      cell.live!
      other_cell.live!

      expect(subject.live_neighbours(cell).count).to eq 1
    end

    it 'cell has live neighbours at the right' do
      cell       = subject.grid[1][1]
      other_cell = subject.grid[2][1]
      cell.live!
      other_cell.live!

      expect(subject.live_neighbours(cell).count).to eq 1
    end

    it 'cell has live neighbours at the bottom' do
      cell       = subject.grid[1][1]
      other_cell = subject.grid[1][2]
      cell.live!
      other_cell.live!

      expect(subject.live_neighbours(cell).count).to eq 1
    end

    it 'cell has live neighbours at the bottom left' do
      cell       = subject.grid[1][1]
      other_cell = subject.grid[0][2]
      cell.live!
      other_cell.live!

      expect(subject.live_neighbours(cell).count).to eq 1
    end

    it 'cell has live neighbours at the bottom right' do
      cell       = subject.grid[1][1]
      other_cell = subject.grid[2][2]
      cell.live!
      other_cell.live!

      expect(subject.live_neighbours(cell).count).to eq 1
    end
  end

  context 'Cell' do
    subject { Cell.new }

    # first rule test was failing because its also counting dead cells,
    # needed to chech a cell is alive first
    it 'alive' do
      expect(subject).to be_alive
    end

    it 'dead' do
      expect(subject).to be_alive
    end

    it 'dies' do
      subject.die!
      expect(subject).to be_dead
    end

    it 'lives' do
      subject.live!
      expect(subject).to be_alive
    end
  end

  context 'Rules' do
    it 'Any live cell with fewer than two live neighbours dies' do
      # I need to check if a Cell has fewer than two neighbours
      # I'll start with an Cell object

      cell = grid.universe.grid[1][1]
      cell.live!

      expect(grid.universe.live_neighbours(cell).count).to eq 0
      # After the neighbour count, need to apply the rules
      # by creating a new generation on the universe
      grid.tick!
      expect(cell).to be_dead
    end

    it 'Any live cell with two or three live neighbours lives' do
      cell          = grid.universe.grid[1][1] # center
      neighbour_one = grid.universe.grid[0][1] # left
      neighbour_two = grid.universe.grid[2][1] # right
      cell.live!
      neighbour_one.live!
      neighbour_two.live!

      expect(grid.universe.live_neighbours(cell).count).to eq 2
      grid.tick!
      expect(cell).to be_alive
    end

    it 'Any live cell with more than three live neighbours dies' do
      cell            = grid.universe.grid[0][1] # left
      neighbour_one   = grid.universe.grid[1][1] # right
      neighbour_two   = grid.universe.grid[1][2] # bottom right
      neighbour_three = grid.universe.grid[0][0] # top
      neighbour_four  = grid.universe.grid[0][2] # bottom

      cell.live!
      neighbour_one.live!
      neighbour_two.live!
      neighbour_three.live!
      neighbour_four.live!

      expect(grid.universe.live_neighbours(cell).count).to eq 4
      grid.tick!
      expect(cell).to be_dead
    end

    it 'Any dead cell with exactly three live neighbours comes back to life' do
      cell            = grid.universe.grid[0][1] # left
      neighbour_one   = grid.universe.grid[1][1] # right
      neighbour_two  = grid.universe.grid[0][2] # bottom
      neighbour_three = grid.universe.grid[0][0] # top

      neighbour_one.live!
      neighbour_two.live!
      neighbour_three.live!

      expect(grid.universe.live_neighbours(cell).count).to eq 3
      grid.tick!
      expect(cell).to be_alive
    end
  end
end
