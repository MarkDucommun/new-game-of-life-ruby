require 'rspec'
require_relative '../sort_set_plane'

describe 'plane' do

  let(:plane) { SortSetPlane.new }

  describe 'creation' do
    it 'can be built gradually' do

      plane.add(-1, 0)
      plane.add 0, 0
      plane.add 1, 0

      expect(plane.living).to eq [coord(-1, 0), coord(0, 0), coord(1, 0)]
    end
  end

  describe 'use living' do
    it 'invokes a method with each living coord' do

      plane.add(-1, 0)
      plane.add 0, 0
      plane.add 1, 0

      coords = plane.use_living(&method(:coord))

      expect(coords).to eq [coord(-1, 0), coord(0, 0), coord(1, 0)]
    end
  end

  describe 'advancing' do
    it 'kills cells with fewer than two neighbors and more than three neighbors' do

      plane.add(-1, 0)
      plane.add 0, 0
      plane.add 1, 0

      plane.next

      expect(plane.living).to eq [coord(0, -1), coord(0, 0), coord(0, 1)]
    end

    skip 'is accurate (r-pentomino has 116 cells at generation 1103)' do

      plane.add(0, -1)
      plane.add(0, 0)
      plane.add(0, 1)
      plane.add(1, 1)
      plane.add(-1, 0)

      1103.times { |i| plane.next }

      expect(plane.living.size).to be 116
    end
  end
end