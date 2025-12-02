ranges = File.read("day_02_input.txt").split(",")

# Part 1 Solution
part_1_sum = 0
ranges.each do |range|
    values = range.split("-")
    start_value = values[0].to_i
    end_value = values[1].to_i

    for i in start_value..end_value do
        # Grab string representation of value
        i_str = i.to_s

        # Ignore values with odd number of digits
        if i_str.length & 0x1 == 1
            next
        end

        # Split string representation in half
        mid_point_idx = i_str.length / 2
        i_str_prefix = i_str[..(mid_point_idx - 1)]
        i_str_suffix = i_str[mid_point_idx..]

        # Is this a repeating sequence?
        if i_str_prefix == i_str_suffix
            part_1_sum += i
        end
    end
end

puts "Part 1 Answer: #{part_1_sum}"

# Part 2 Solution (brute force)
part_2_sum = 0
ranges.each do |range|
    values = range.split("-")
    start_value = values[0].to_i
    end_value = values[1].to_i

    for i in start_value..end_value do
        # Grab string representation of value
        i_str = i.to_s

        for sequence_digit_count in (i_str.length / 2).downto(1) do
            # Ignore if digit count doesn't divide value evenly
            if i_str.length % sequence_digit_count != 0
                next
            end

            # Break it multple strings of size 'sequence_digit_count'
            sequences = i_str.scan(/.{#{sequence_digit_count}}/)

            # Check if they all match
            all_sequences_match = true
            for sequence_idx in 1..sequences.length - 1 do
                if sequences[0] != sequences[sequence_idx]
                    all_sequences_match = false
                    break
                end
            end

            if all_sequences_match
                part_2_sum += i
                break
            end
        end
    end
end

puts "Part 2 Answer: #{part_2_sum}"