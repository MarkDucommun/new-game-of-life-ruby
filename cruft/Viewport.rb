require 'set'
require 'colorize'
require_relative 'Plane'

class Viewport

  def initialize(plane, upper_left, x_size, y_size)
    @plane = plane
    @upper_left = upper_left
    @x_size = x_size
    @y_size = y_size
  end

  def next
    @plane = @plane.next
  end

  def rendered_cells
    @plane.cells.select do |cell|
      cell.x >= @upper_left.x && cell.x < @upper_left.x + @x_size &&
        cell.y <= @upper_left.y && cell.y > @upper_left.y - @y_size
    end
  end

  def alive_coordinates
    rendered_cells.map do |cell|
      Coord.new(plane_to_viewport_x(cell.x), plane_to_viewport_y(cell.y))
    end.to_set
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
        alive(coords, Coord.new(x, y)) ? "x".red : "o"
      end.join(" ")
    end.join("\n") << "\n"
  end
end

def alive(coords, coord)
  !coords.select {|a_coord| a_coord.x == coord.x && a_coord.y == coord.y}.first.nil?
end
