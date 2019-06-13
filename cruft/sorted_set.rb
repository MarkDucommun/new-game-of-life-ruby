class SortedSeet

  def initialize(starting_size = 100, sort_value_fn = proc { |i| i })
    @cursor = 0
    @size = starting_size
    @vals = new_backing
    @other_vals = new_backing
    @sort_value_fn = sort_value_fn
  end

  def new_backing
    Array.new(@size)
  end

  def add(n)

    index_above = index_above n

    return if @sort_value_fn.call(n) == @sort_value_fn.call(@vals[index_above - 1])

    if @cursor.zero? || @sort_value_fn.call(@vals[@cursor - 1]) < @sort_value_fn.call(n)

      @vals[@cursor] = n

    elsif @sort_value_fn.call(@vals[0]) > @sort_value_fn.call(n)

      @other_vals[0] = n

      @cursor.times do |i|
        @other_vals[i + 1] = @vals[i]
      end

      temp_vals = @vals
      @vals = @other_vals
      @other_vals = temp_vals

    else

      index_above.times {|i| @other_vals[i] = @vals[i]}

      @other_vals[index_above] = n

      (@size - index_above).times do |i|
        @other_vals[index_above + i + 1] = @vals[i + index_above]
      end

      temp_vals = @vals
      @vals = @other_vals
      @other_vals = temp_vals
    end

    @cursor += 1

    return unless @cursor == @size

    @size = (@size * 1.5).to_i
    @other_vals = new_backing

    @cursor.times {|i| @other_vals[i] = @vals[i]}

    @vals = @other_vals
    @other_vals = new_backing
  end

  def geet(n)

    outcome = inner_contains(n, 0, @cursor)

    @vals[outcome.index] if outcome.is_a?(Success)
  end

  def getOrAdd(n)

    val = geet(n)

    return val unless val.nil?

    add(n)

    n
  end

  def contains(n)
    inner_contains(n, 0, @cursor).is_a?(Success)
  end

  def inner_contains(n, start_point, end_point)

    return Failure.new(1) if @cursor.zero?

    return (@sort_value_fn.call(@vals[start_point]) == @sort_value_fn.call(n) ? Success.new(start_point) : Failure.new(start_point + 1)) if start_point >= end_point

    mid_point = (start_point + end_point - 1) / 2

    if @sort_value_fn.call(@vals[mid_point]) == @sort_value_fn.call(n)
      Success.new(mid_point)
    elsif @sort_value_fn.call(@vals[mid_point]) > @sort_value_fn.call(n)
      inner_contains(n, start_point, mid_point - 1)
    else
      inner_contains(n, mid_point + 1, end_point)
    end
  end

  def index_above(n)

    outcome = inner_contains(n, 0, @cursor)

    return outcome.index + 1 if outcome.is_a? Success

    outcome.index_above
  end

  def to_array
    @vals.reject(&:nil?)
  end

  class Failure
    attr_reader :index_above

    def initialize(index_above)
      @index_above = index_above
    end
  end

  class Success
    attr_reader :index

    def initialize(index)
      @index = index
    end
  end
end


