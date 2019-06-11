Coord = Struct.new(:x, :y) do
  def +(coord)
    Coord.new(x + coord.x, y + coord.y) if coord.respond_to?(:x) && coord.respond_to?(:y)
  end
end