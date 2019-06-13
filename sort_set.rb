require_relative 'sort_set_builder'
require_relative 'sort_set_finder'

# A sorted set
class SortSet
  include SortSetBuilder
  include SortSetFinder

  def initialize(size = 10, &sort_value)
    setup_builder(size, &sort_value)
    setup_finder size
  end

  def add(value)

    outcome = find_index value

    return if outcome.is_a? IndexSuccess

    add_at(outcome.future_index, value)
  end

  def include?(value)

    find_index(value).is_a? IndexSuccess
  end

  def find(value)

    outcome = find_index value

    return if outcome.is_a? IndexFailure

    values[outcome.index]
  end

  def find_or_add(value)

    outcome = find_index value

    add_at(outcome.future_index, value) if outcome.is_a? IndexFailure

    outcome.is_a?(IndexSuccess) ? get(outcome.index) : value
  end

  def find_index(value)

    find_index_internal(0, less_one(cursor), value)
  end

  def to_a
    values
  end
end

