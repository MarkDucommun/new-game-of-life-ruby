require_relative 'sort_set'
require_relative 'column'

class SortSetPlane

  def initialize
    @raw_living = column_set
    @might_live = column_set
    @will_live = column_set
  end

  def add(x, y)
    add_to_set(raw_living, x, y)
  end

  def next

    generate_coords_that_might_live

    evaluate_coords_that_might_live

    reset_coord_sets
  end

  def living
    use_living(&method(:coord))
  end

  def use_living(&use_coords)
    use_coords_from_set(raw_living, &use_coords)
  end

  private

  attr_reader :raw_living, :might_live, :will_live

  def generate_coords_that_might_live
    use_living(&method(:add_coord_and_neighbors_to_might_live))
  end

  def add_coord_and_neighbors_to_might_live(x, y)
    add_to_might_live(x, y)
    neighbors(x, y, &method(:add_to_might_live))
  end

  def evaluate_coords_that_might_live
    use_might_live(&method(:add_coord_to_will_live_if_should_live))
  end

  def add_coord_to_will_live_if_should_live(x, y)
    add_to_will_live(x, y) if should_live(x, y)
  end

  def reset_coord_sets
    @raw_living = will_live
    @might_live = column_set
    @will_live = column_set
  end

  def should_live(x, y)
    count = alive_neighbors(x, y)
    count == 3 || count == 2 && alive(x, y)
  end

  def alive(x, y)
    raw_living.find(coord(x, nil))&.ys&.include?(y) || false
  end

  def alive_neighbors(x, y)
    neighbors(x, y, &method(:alive)).select { |it| it }.size
  end

  def add_to_set(set, x, y)
    set.find_or_add(column(x)).ys.add y
  end

  def add_to_might_live(x, y)
    add_to_set(might_live, x, y)
  end

  def add_to_will_live(x, y)
    add_to_set(will_live, x, y)
  end

  def use_coords_from_set(set, &use_coords)
    set.to_a.map { |column| column.use_coords(&use_coords) }.flatten
  end

  def use_might_live(&use_coords)
    might_live.to_a.map { |column| column.use_coords(&use_coords) }
  end

  def column_set
    SortSet.new(100, &:x)
  end
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
  NEIGHBOR_TRANSFORMS.map { |transform| use_neighbor.call(x + transform.x, y + transform.y) }
end