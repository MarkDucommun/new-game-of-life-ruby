require_relative 'sort_set'
require_relative 'column'

class RunLengthEncodedParser

  def parse_and_use(pattern, &use_coords)

    lines = pattern.split("\n")

    headers = Headers.new(lines.shift)

    process = lambda do |row, inverse_y|
      process_row(row, headers.x_offset, -inverse_y, &use_coords)
    end

    process_lines(lines)
      .map
      .with_index(headers.y_offset, &process)
      .flatten
  end

  def process_lines(lines)
    lines
      .map(&:strip)
      .join('')
      .split('!')
      .first
      .split('$')
      .map { |row| row.split '' }
  end

  def process_row(row, x_offset, y, &use_coords)

    x_cursor = x_offset

    increment_cursor = ->(amt = 1) { x_cursor += amt }

    results = []

    until row.empty?

      char = row.shift

      if char.match(/\d/)

        count = char.to_i
        cell = row.shift

        count.times { |i| results << use_coords.call(i + x_cursor, y) } if cell == 'o'

        increment_cursor count
      else

        results << use_coords.call(x_cursor, y) if char == 'o'

        increment_cursor
      end
    end

    results
  end

  def parse(pattern)
    parse_and_use(pattern, &method(:coord))
  end
end

class Headers

  attr_reader :x_offset, :y_offset

  def initialize(header_line)

    @header_hash = {}

    create_header_hash(header_line)

    set_x_offset
    set_y_offset
  end

  def create_header_hash(line)
    line
      .split(',')
      .map { |key_value| key_value.split('=').map(&:strip) }
      .each { |key, value| @header_hash[key] = value }
  end

  def set_x_offset
    @x_offset = -(@header_hash['x'].to_i / 2)
  end

  def set_y_offset
    @y_offset = -(@header_hash['y'].to_i / 2)
  end
end