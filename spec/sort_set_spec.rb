require 'rspec'
require_relative '../sort_set'

describe 'sort set' do

  let(:set) { SortSet.new }

  it 'can add items in sequential order' do

    set.add 1
    set.add 2
    set.add 3

    expect(set.to_a).to eq([1, 2, 3])
  end

  it 'can add items in reverse sequential order' do

    set.add 3
    set.add 2
    set.add 1

    expect(set.to_a).to eq([1, 2, 3])
  end

  it 'can add items to the middle order' do

    set.add 1
    set.add 3
    set.add 2

    expect(set.to_a).to eq([1, 2, 3])
  end

  it 'can provide the value to sort by through ad hoc polymorphism' do

    A = Struct.new(:a)

    special_set = SortSet.new(&:a)

    special_set.add A.new(1)
    special_set.add A.new(3)
    special_set.add A.new(2)
    special_set.add A.new(0)

    expect(special_set.to_a).to eq([0, 1, 2, 3].map { |i| A.new(i) })
  end
end
