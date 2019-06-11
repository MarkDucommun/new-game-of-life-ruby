# frozen_string_literal: true

require 'set'
require_relative 'Coord'

class Plane

  attr_reader :cells

  def initialize(cells)
    @cells = cells.to_set
  end

  @@neighbor_transforms = Set[
    Coord.new(0, 1),
    Coord.new(1, 1),
    Coord.new(1, 0),
    Coord.new(1, -1),
    Coord.new(0, -1),
    Coord.new(-1, -1),
    Coord.new(-1, 0),
    Coord.new(-1, 1)
  ].freeze

  def should_live(coord)
    neighbor_count = alive_neighbors(coord)
    neighbor_count == 3 || alive(coord) && neighbor_count == 2
  end

  def alive_neighbors(coord)
    neighbor_coords(coord).select { |neighbor| alive(neighbor) }.length
  end

  def neighbor_coords(coord)
    @@neighbor_transforms.map { |transform| transform + coord }
  end

  def alive(coord)
    !cells.select { |cell| cell.x == coord.x && cell.y == coord.y }.first.nil?
  end

  def ==(other)
    cells == other.cells if other.respond_to?(:cells)
  end

  def next

    return @next_plane unless @nextPlane.nil?

    living_coords = @cells
                      .map { |cell| neighbor_coords(cell).push(cell) }
                      .flatten
                      .uniq
                      .select(&method(:should_live))

    @next_plane = Plane.new(living_coords)

    @next_plane

  end

  def should_die
    @cells - self.next.cells
  end

  def should_come_alive
    self.next.cells - @cells
  end
end