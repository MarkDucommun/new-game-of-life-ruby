require 'rspec'
require_relative '../sorted_set'

describe 'sorted sets' do
  it 'can add' do

    set = SortedSeet.new
    set.add 1
    set.add 3
    set.add 5
    set.add 7
    set.add 9

    expect(set.contains(1)).to be_truthy
    expect(set.contains(3)).to be_truthy
    expect(set.contains(5)).to be_truthy
    expect(set.contains(7)).to be_truthy
    expect(set.contains(9)).to be_truthy

    expect(set.contains(6)).to be_falsey
    expect(set.contains(0)).to be_falsey
    expect(set.contains(10)).to be_falsey
  end

  it 'can find the index just above a value' do
    set = SortedSeet.new
    set.add 1
    set.add 3
    set.add 5
    set.add 7
    set.add 9

    expect(set.index_above(1)).to be 1
    expect(set.index_above(2)).to be 2
    expect(set.index_above(9)).to be 5
  end

  it 'can insert intermediate values' do
    set = SortedSeet.new
    set.add 1
    set.add 3
    set.add 2

    p set.to_array
  end

  it 'can grow' do
    set = SortedSeet.new 2
    set.add 1
    set.add 3
    set.add 2
    set.add 5
    set.add 7
    set.add 4

    p set.to_array
  end

  it 'can sort different things' do
    a = Struct.new(:b, :y)

    set = SortedSeet.new(100, proc { |o| o.b if o.respond_to?(:b) })
    set.add a.new(1, 2)
    set.add a.new(2, 2)
    set.add a.new(3, 2)
  end

  it 'can add a bad sequence of numbers' do

    set = SortedSeet.new

    [3, 2, 3, 2, -1, 0, 3, 2, -1, -1, 0, 0, 2].each { |i| set.add i }

    expect(set.to_array).to eq([-1, 0, 2, 3])
  end
end