require_relative 'sorted_set'
require_relative 'Coord'
require_relative 'plane'
require_relative 'Viewport'
require 'colorize'


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

CoordHolder = Struct.new(:x, :ys).freeze

def neighbors(coord)
  NEIGHBOR_TRANSFORMS.map { |transform| transform + coord }
end

class BetterPlane

  def initialize
    @bads = []
    @generation = 0
    @xs = SortedSeet.new(100, proc { |i| i.x if i.respond_to?(:x) })
    @next_xs = SortedSeet.new(100, proc { |i| i.x if i.respond_to?(:x) })
  end

  def add(x, y)
    c = CoordHolder.new(x, SortedSeet.new(100))
    coord_holder = @xs.getOrAdd(c)
    coord_holder.ys.add(y)
  end

  def add_next(x, y)
    c = CoordHolder.new(x, SortedSeet.new(100))
    coord_holder = @next_xs.getOrAdd(c)
    if (x == -3 && @generation == 16)
      @bads << y
    end
    coord_holder.ys.add(y)
  end

  def alive(coord)
    ys = @xs.geet(coord)

    return false if ys.nil?

    !ys.ys.geet(coord.y).nil?
  end

  def alive_neighbors(coord)
    neighbors(coord).select { |neighbor| alive(neighbor) }.length
  end

  def should_live(coord)
    neighbor_count = alive_neighbors(coord)
    neighbor_count == 3 || alive(coord) && neighbor_count == 2
  end

  def living_cells
    @xs
      .to_array
      .map { |row| row.ys.to_array.map { |y| Coord.new(row.x, y) } }
      .flatten
  end

  def next
    @generation += 1
    # dead_cells = SortedSet.new(100, proc {|i| i.x if i.respond_to?(:x)})

    puts "NEXT"

    living_cells.map do |cell|
      neighbors(cell).push(cell).each do |neighbor|
        puts neighbor if neighbor.x == -3
        add_next(neighbor.x, neighbor.y) if should_live(neighbor)
      end
    end

    @xs = @next_xs
    @next_xs = SortedSeet.new(100, proc { |i| i.x if i.respond_to?(:x) })
  end

  def three_one
    @bads
  end
end

X = 'x'.red.freeze
O = 'o'.freeze
SPACE = ' '.freeze
NEWLINE = "\n".freeze

class Newport

  def initialize(plane, upper_left, x_size, y_size)
    @plane = plane
    @upper_left = upper_left
    @x_size = x_size
    @y_size = y_size
  end

  def next
    @plane.next
  end

  def rendered_cells
    @plane.living_cells.select do |cell|
      cell.x >= @upper_left.x && cell.x < @upper_left.x + @x_size &&
        cell.y <= @upper_left.y && cell.y > @upper_left.y - @y_size
    end
  end

  def alive_coordinates
    rendered_cells.map do |cell|
      Coord.new(plane_to_viewport_x(cell.x), plane_to_viewport_y(cell.y))
    end
  end

  def plane_to_viewport_x(x)
    x - @upper_left.x
  end

  def plane_to_viewport_y(y)
    -y + @upper_left.y
  end

  def to_s

    coords = alive_coordinates

    (0...@y_size).map do |y|
      (0...@x_size).map do |x|
        alive(coords, Coord.new(x, y)) ? X : O
      end.join(SPACE)
    end.join(NEWLINE) << NEWLINE
  end
end

def alive(coords, coord)
  !coords.select {|a_coord| a_coord.x == coord.x && a_coord.y == coord.y}.first.nil?
end

PLANE = BetterPlane.new

OLD_PLANE = Plane.new([Coord.new(-1, -1), Coord.new(-1, 0), Coord.new(-1, 1), Coord.new(0, 1), Coord.new(-2, 0)])

PLANE.add(-1, -1)
PLANE.add(-1, 0)
PLANE.add(-1, 1)
PLANE.add(0, 1)
PLANE.add(-2, 0)

puts "initial: #{PLANE.living_cells.to_set == OLD_PLANE.cells}"

19.times do |i|
  puts "#{i}: #{PLANE.living_cells.to_set == OLD_PLANE.cells}"

  # puts Newport.new(PLANE, Coord.new(-10, 4), 14, 10)
  # puts "---"
  # puts Viewport.new(OLD_PLANE, Coord.new(-10, 4), 14, 10)

  PLANE.next

  OLD_PLANE = OLD_PLANE.next
end

NEW = PLANE.living_cells.to_set
OLD = OLD_PLANE.cells

p PLANE.three_one

OLD_PLANE.neighbor_coords(Coord.new(-2, 0)).map { |i| puts "#{i} - old #{OLD_PLANE.alive(i)} - new #{PLANE.alive(i)}"}

p NEW - OLD
# p OLD - NEW

#

# viewport = Newport.new(PLANE, Coord.new(-50, 50), 100, 100)
#
# puts `clear`
#
# 1000.times do
#
#   puts viewport.to_s
#
#   sleep(0.2)
#
#   puts `clear`
#
#   viewport.next
# end