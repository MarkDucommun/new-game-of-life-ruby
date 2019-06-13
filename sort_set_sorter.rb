module SortSetSorter

  def __setup_sorter__(&sort_value)
    @sort_value = sort_value || ->(it) {it}
  end

  def less_than(first, second)
    @sort_value.call(first) < @sort_value.call(second)
  end

  def greater_than(first, second)
    @sort_value.call(first) > @sort_value.call(second)
  end
end
