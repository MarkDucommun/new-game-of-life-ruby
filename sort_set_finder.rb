require_relative 'sort_set_values'


# Searches a sorted set
module SortSetFinder
  include SortSetValues

  def setup_finder(size)
    setup_values(size)
  end

  def find_index_internal(start_index, end_index, value)

    return IndexFailure.new(0) if cursor.zero?

    mid_index = (end_index + start_index) / 2

    if equal?(values[mid_index], value)

      IndexSuccess.new(mid_index)
    elsif start_index == end_index

      find_index_base_case(mid_index, value)
    else

      find_index_recurse(start_index, mid_index, end_index, value)
    end
  end

  def find_index_recurse(start_index, mid_index, end_index, value)

    if greater_than?(get(mid_index), value)

      find_index_internal(start_index, less_one(mid_index), value)
    else

      find_index_internal(plus_one_or_max(mid_index, end_index), end_index, value)
    end
  end

  def find_index_base_case(index, value)

    IndexFailure.new(less_than?(get(index), value) ? index + 1 : index)
  end

  def less_one(int)
    int.zero? ? 0 : int - 1
  end

  def plus_one_or_max(int, max)
    int >= max ? max : int + 1
  end
end