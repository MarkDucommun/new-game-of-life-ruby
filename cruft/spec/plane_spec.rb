require 'rspec'
require_relative '../cruft/rb'

describe 'Game of Life' do
  it 'kills cells with fewer than two neighbors' do
    plane = Plane.new([Coord.new(0, 0)])

    expect(plane.next).to eq(Plane.new([]))
  end

  it 'returns cells with three neighbors to life' do
    plane = Plane.new([Coord.new(0, 0), Coord.new(-1, 0), Coord.new(1, 0)])

    expected = Plane.new([Coord.new(0, 0), Coord.new(0, -1), Coord.new(0, 1)])

    expect(plane.next).to eq(expected)
  end

  it 'can determine which cells should die' do
    plane = Plane.new([Coord.new(0, 0), Coord.new(-1, 0), Coord.new(1, 0)])

    expect(plane.should_die).to eq(Set[Coord.new(-1, 0), Coord.new(1, 0)])
  end

  it 'can determine which cells should come to life' do
    plane = Plane.new([Coord.new(0, 0), Coord.new(-1, 0), Coord.new(1, 0)])

    expect(plane.should_come_alive).to eq(Set[Coord.new(0, -1), Coord.new(0, 1)])
  end

  it 'can determine how many alive neighbors a cell has' do
    plane = Plane.new([Coord.new(1, 0), Coord.new(0, 1)])

    expect(plane.alive_neighbors(Coord.new(0, 0))).to be(2)
  end

  context 'alive' do
    it 'returns true if cell is alive' do
      expect(Plane.new([Coord.new(0,0)]).alive(Coord.new(0, 0))).to be_truthy
    end

    it 'returns false if cell is dead' do
      expect(Plane.new([]).alive(Coord.new(0, 0))).to be_falsey
    end
  end

  context 'Coord' do
    it 'can add coords' do
      expect(Coord.new(0, 0) + Coord.new(1, 1)).to eq(Coord.new(1,1))
    end
  end
end