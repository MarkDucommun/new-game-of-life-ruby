require_relative 'Viewport'

plane = Plane.new([Coord.new(-1, -1), Coord.new(-1, 0), Coord.new(-1, 1), Coord.new(0, 1), Coord.new(-2, 0)])

viewport = Viewport.new(plane, Coord.new(-50, 20), 100, 40)

puts `clear`


1000.times do

  puts viewport.to_s

  sleep(0.5)

  puts `clear`

  viewport.next
end

