module SortSetBuilder

  def __setup_builder__
    @alternate = Array.new
  end

  def __add_to_end__(value)
    @values << value
  end

  def __add_to_beginning__(value)
    @values.unshift value
  end

  def __add_to_middle__(value)

    @value_added = false

    __transfer_next_and_maybe_add__ value until @values.empty?

    @values = @alternate
    @alternate = Array.new
  end

  def __transfer_next_and_maybe_add__(value)

    transfer = @values.shift

    if less_than(value, transfer) && !@value_added

      @alternate << value
      @value_added = true
    end

    @alternate << transfer
  end
end
