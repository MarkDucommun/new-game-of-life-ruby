require 'rspec'
require_relative '../cruft/rt'

describe 'viewport' do

  it 'can frame a plane' do
    plane = Plane.new([Coord.new(0, 0), Coord.new(-1, 0), Coord.new(1, 0)])

    viewport = Viewport.new(plane, Coord.new(-2, 2), 5, 5)

    set = Set[Coord.new(1, 2), Coord.new(2, 2), Coord.new(3, 2)]

    expect(viewport.alive_coordinates).to eq(set)
  end

  it 'should convert the current plane to a string' do
    plane = Plane.new([Coord.new(0, 0), Coord.new(-1, 0), Coord.new(1, 0)])

    viewport = Viewport.new(plane, Coord.new(-2, 2), 5, 5)

    expected = <<EOD
o o o o o
o o o o o
o x x x o
o o o o o
o o o o o
EOD

    expect(viewport.to_s).to eq(expected)
  end
end
