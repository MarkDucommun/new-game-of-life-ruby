require_relative 'sort_set'

class SortSetPlane

  def initialize
    @columns = SortSet.new(100, &:x)
    @to_examine = SortSet.new(100, &:x)
    @lives = SortSet.new(100, &:x)
  end

  def add(x, y)
    @columns.find_or_add(column(x)).ys.add y
  end

  def next
    @columns.to_a.each do |column|
      column.use_coords do |x, y|

        @to_examine.find_or_add(column(x)).ys.add y

        neighbors(x, y) do |neighbor_x, neighbor_y|

          @to_examine.find_or_add(column(neighbor_x)).ys.add neighbor_y
        end
      end
    end

    @to_examine.to_a.each do |column|
      column.use_coords do |x, y|
        @lives.find_or_add(column(x)).ys.add y if should_live(x, y)
      end
    end

    @columns = @lives
    @to_examine = SortSet.new 100
    @lives = SortSet.new 100
  end

  def living
    @columns.to_a.map(&:coords).flatten
  end

  private

  def should_live(x, y)
    count = alive_neighbors(x, y)
    count == 3 || count == 2 && alive(x, y)
  end

  def alive(x, y)
    @columns.find(coord(x, nil))&.ys&.include?(y) || false
  end

  def alive_neighbors(x, y)
    neighbors(x, y, &method(:alive)).select {|it| it}.size
  end
end

Column = Struct.new(:x, :ys) do

  def coords
    ys.to_a.map {|y| coord(x, y)}
  end

  def use_coords(&use_coord)
    ys.to_a.map {|y| use_coord.call(x, y)}
  end
end

Coord = Struct.new(:x, :y)

def coord(x, y)
  Coord.new(x, y)
end

def column(x)
  Column.new(x, SortSet.new(50))
end

NEIGHBOR_TRANSFORMS = [
  Coord.new(0, 1).freeze,
  Coord.new(1, 1).freeze,
  Coord.new(1, 0).freeze,
  Coord.new(1, -1).freeze,
  Coord.new(0, -1).freeze,
  Coord.new(-1, -1).freeze,
  Coord.new(-1, 0).freeze,
  Coord.new(-1, 1).freeze
].freeze

def neighbors(x, y, &use_neighbor)
  NEIGHBOR_TRANSFORMS.map {|transform| use_neighbor.call(x + transform.x, y + transform.y)}
end