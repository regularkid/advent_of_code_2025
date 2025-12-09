# Part 1
Tile = Struct.new(:x, :y)

tiles = []
File.readlines("day_09_input.txt").each do |line|
    values = line.strip.split(",")
    tiles.push(Tile.new(values[0].to_i, values[1].to_i))
end

largest_area = 0
for a_idx in 0...tiles.length
    for b_idx in 0...tiles.length
        if a_idx == b_idx
            next
        end

        dx = (tiles[a_idx].x - tiles[b_idx].x + 1).abs
        dy = (tiles[a_idx].y - tiles[b_idx].y + 1).abs
        area = dx * dy
        largest_area = (area > largest_area) ? area : largest_area
    end
end

puts "Part 1 Answer: #{largest_area}"

# Part 2 - ??