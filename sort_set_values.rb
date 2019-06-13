# Backing structure for sorted set
module SortSetValues

  private

  attr_reader :size, :cursor

  def setup_values(size)

    return if @initialized

    @initialized = true
    @size = size
    @cursor = 0
    @values = create_array
  end

  def create_array
    Array.new(size)
  end

  def increment_cursor
    @cursor += 1
  end

  def get(index)
    raw_values[index]
  end

  def raw_values
    @values
  end

  def values
    raw_values.slice(0...cursor)
  end

  def set_value(index, value)
    raw_values[index] = value
  end

  def reset_values(values)
    @values = values
  end

  def grow
    @size *= 2
    temp = raw_values
    reset_values create_array

    cursor.times { |index| set_value(index, temp[index]) }
  end
end