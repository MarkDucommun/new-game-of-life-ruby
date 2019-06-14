require_relative 'coord'

Column = Struct.new(:x, :ys) do

  def coords
    use_coords { |y| coord(x, y) }
  end

  def use_coords(&use_coord)
    ys.to_a.map { |y| use_coord.call(x, y) }
  end
end

def column(x)
  Column.new(x, SortSet.new(50))
end
