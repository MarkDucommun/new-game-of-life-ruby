require 'rspec'
require_relative '../sort_set'

describe 'sort set' do

  let(:simple) { Struct.new(:a) }
  let(:complex) { Struct.new(:a, :b) }

  let(:set) { SortSet.new }
  let(:special_set) { SortSet.new(&:a) }

  it 'can add items in sequential order' do

    set.add 1
    set.add 2
    set.add 3

    expect(set.to_a).to eq [1, 2, 3]
  end

  it 'can add items in reverse sequential order' do

    set.add 3
    set.add 2
    set.add 1

    expect(set.to_a).to eq [1, 2, 3]
  end

  it 'can add items to the middle order' do

    set.add 2
    set.add 4
    set.add 6
    set.add 1
    set.add 3
    set.add 5

    expect(set.to_a).to eq [1, 2, 3, 4, 5, 6]
  end

  it 'will not add duplicates' do

    set.add 1
    set.add 3
    set.add 1
    set.add 2
    set.add 1

    expect(set.to_a).to eq [1, 2, 3]
  end

  it 'can provide the value to sort by through ad hoc polymorphism' do

    special_set.add simple.new(1)
    special_set.add simple.new(3)
    special_set.add simple.new(2)
    special_set.add simple.new(0)

    expect(special_set.to_a).to eq([0, 1, 2, 3].map { |i| simple.new(i) })
  end

  it 'growing the underlying array does not blow up' do

    small_set = SortSet.new 3

    10.times { |i| small_set.add i }

    expect(small_set.to_a).to eq (0..9).to_a
  end

  describe 'include?' do
    it 'returns true if it does contain the item' do

      set.add 3
      set.add 2
      set.add 1

      expect(set.include?(3)).to be_truthy
    end

    it 'returns false if it does not contain the item' do

      set.add 3
      set.add 2
      set.add 1

      expect(set.include?(4)).to be_falsey
    end

    it 'works with ad hoc polymorphism comparison' do

      special_set.add complex.new(1, [:a])

      expect(special_set.include?(Struct.new(:a).new(1))).to be_truthy
    end
  end

  describe 'find' do
    it 'returns the object if it is contained in the set' do

      special_set.add complex.new(1, [:a])
      special_set.add complex.new(3, [:a])
      special_set.add complex.new(2, [:B])
      special_set.add complex.new(0, [:A])
      special_set.add complex.new(5, [:A])
      special_set.add complex.new(4, [:A])

      expect(special_set.find(Struct.new(:a).new(1))).to eq complex.new(1, [:a])
    end

    it 'returns nil if the object is not present' do

      special_set.add complex.new(1, [:a])

      expect(special_set.find(Struct.new(:a).new(2))).to be_nil
    end
  end

  describe 'find or add' do
    it 'returns the object if it is contained in the set' do

      special_set.add complex.new(1, [:a])

      probe = complex.new(1, [])

      expect(special_set.find_or_add(probe)).to eq complex.new(1, [:a])
    end

    it 'adds the object if it not contained in the set' do

      special_set.add complex.new(1, [:a])

      probe = complex.new(2, [])

      expect(special_set.find_or_add(probe)).to eq complex.new(2, [])
    end
  end

  describe 'find index' do
    describe 'value exists' do
      it 'returns a single item' do

        set.add 1

        outcome = set.find_index 1

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be(0)
      end

      it 'finds the beginning value' do

        set.add 1
        set.add 2
        set.add 3
        set.add 4

        outcome = set.find_index 1

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 0

        set.add(5)

        outcome = set.find_index 1

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 0
      end

      it 'finds the end value' do

        set.add 1
        set.add 2
        set.add 3
        set.add 4

        outcome = set.find_index 1

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 0

        set.add(5)

        outcome = set.find_index 1

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 0
      end

      it 'can find middle values' do

        set.add 2
        set.add 4
        set.add 6
        set.add 8

        outcome = set.find_index 4

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 1

        outcome = set.find_index 6

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 2

        set.add 10

        outcome = set.find_index 4

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 1

        outcome = set.find_index 6

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 2

        outcome = set.find_index 8

        expect(outcome).to be_a IndexSuccess
        expect(outcome.index).to be 3
      end

    end

    describe 'value does not exist' do
      it 'empty' do

        outcome = set.find_index 1

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 0
      end

      it 'can place something at the beginning' do

        set.add 1
        set.add 2
        set.add 3
        set.add 4

        outcome = set.find_index 0

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 0

        set.add 5

        outcome = set.find_index 0

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 0
      end

      it 'can place something at the end' do

        set.add 1
        set.add 2
        set.add 3
        set.add 4

        outcome = set.find_index 5

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 4

        set.add 5

        outcome = set.find_index 6

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 5
      end

      it 'can place something in the middle' do

        set.add 2
        set.add 4
        set.add 6
        set.add 8

        outcome = set.find_index 3

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 1

        outcome = set.find_index 5

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 2

        outcome = set.find_index 7

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 3

        set.add 10

        outcome = set.find_index 3

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 1

        outcome = set.find_index 5

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 2

        outcome = set.find_index 7

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 3


        outcome = set.find_index 9

        expect(outcome).to be_a IndexFailure
        expect(outcome.future_index).to be 4
      end
    end
  end
end
