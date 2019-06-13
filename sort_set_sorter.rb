module SortSetSorter

  private

  def setup_sorter(&sort_value)
    @sort_value = sort_value || ->(it) { it }
  end

  def less_than?(first, second)
    extract(first) < extract(second)
  end

  def greater_than?(first, second)
    extract(first) > extract(second)
  end

  def equal?(first, second)
    extract(first) == extract(second)
  end

  def extract(value)
    @sort_value.call(value)
  end
end
