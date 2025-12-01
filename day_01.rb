dial_position = 50
num_zeros_after_rotation = 0
num_zeros_during_rotation = 0

File.readlines("day_01_input.txt").each do |line|
    # Parse input
    rotation_direction = (line[0] == 'L') ? -1 : 1
    rotation_distance = line[1..].to_i

    # Calculate how many "full" revolutions this rotation will make. These won't change the final
    # dial position, but will wrap around zero, so just count them up and reduce the distance.
    num_full_rotations = rotation_distance / 100
    num_zeros_during_rotation += num_full_rotations
    rotation_distance += num_full_rotations * 100 * -rotation_distance    

    # Calculate new dial position
    dial_position_last = dial_position
    dial_position = (dial_position + (rotation_direction * rotation_distance)) % 100

    # Did we end at zero?
    if dial_position == 0
        num_zeros_after_rotation += 1
    # Did we wrap around zero?
    elsif dial_position_last != 0
        if (rotation_direction == -1 and dial_position > dial_position_last) or
           (rotation_direction == 1 and dial_position < dial_position_last)
           num_zeros_during_rotation += 1
        end
    end
end

puts "Part 1 Answer: #{num_zeros_after_rotation}"
puts "Part 2 Answer: #{num_zeros_after_rotation + num_zeros_during_rotation}"