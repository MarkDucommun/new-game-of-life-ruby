require_relative 'sort_set_values'
require_relative 'sort_set_sorter'

# Builds sorted set
module SortSetBuilder
  include SortSetSorter
  include SortSetValues

  private

  attr_reader :alternate

  def setup_builder(size, &sort_value)
    setup_values(size)
    setup_sorter(&sort_value)
    @alternate = create_array
  end

  def add_at(index, value)

    grow_backing if cursor == size

    index == cursor ? add_to_end(value) : add_internal(value, index)
  end

  def add_to_end(value)
    set_value(cursor, value)
    increment_cursor
  end

  def add_internal(value, index)

    index.times { |i| transfer_value(i, i) }

    set_alternate_value(index, value)

    cursor.times { |i| transfer_value(i + index, i + index + 1) }

    temp = values
    reset_values alternate
    reset_alternate temp

    increment_cursor
  end

  def set_alternate_value(index, value)
    alternate[index] = value
  end

  def reset_alternate(alternate)
    @alternate = alternate
  end

  def transfer_value(value_index, alternate_index)
    set_alternate_value(alternate_index, get(value_index))
  end

  def grow_backing
    grow
    reset_alternate create_array
  end
end

IndexSuccess = Struct.new(:index)
IndexFailure = Struct.new(:future_index)