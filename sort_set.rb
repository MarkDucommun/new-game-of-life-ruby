require_relative 'sort_set_sorter'
require_relative 'sort_set_builder'

class SortSet
  include SortSetSorter
  include SortSetBuilder

  def initialize(&sort_value)
    @values = Array.new
    __setup_builder__
    __setup_sorter__ &sort_value
  end

  def add(value)

    return __add_to_end__ value if empty? || greater_than(value, @values.last)

    return __add_to_beginning__ value if less_than(value, @values.first)

    __add_to_middle__ value
  end

  def empty?
    @values.empty?
  end

  def to_a
    @values
  end
end

