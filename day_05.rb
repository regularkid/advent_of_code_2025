require 'set'

fresh_ranges = []
all_ranges_found = false
num_fresh_ingredients = 0

File.readlines("day_05_input.txt").each do |line|
    line = line.strip

    # Find empty line in between ranges and ingredient IDs
    if line.length == 0
        all_ranges_found = true
        next
    end

    # Reading in ranges?
    if not all_ranges_found
        values = line.split('-')
        fresh_ranges.push({min:values[0].to_i, max:values[1].to_i})
    # Reading in ingredient IDs?
    else
        ingredient_id = line.to_i
        fresh_ranges.each do |range|
            if ingredient_id >= range[:min] and ingredient_id <= range[:max]
                num_fresh_ingredients += 1
                break
            end
        end
    end
end

puts "Part 1 Answer: #{num_fresh_ingredients}"

def does_range_overlap(range_a, range_b)
    if range_a[:max] < range_b[:min] or
       range_a[:min] > range_b[:max]
        return false
    end

    return true
end

# Part 2: Count total number of fresh ingredient IDs
# Merge ranges so that there are no overlaps
range_a_idx = 0
while range_a_idx < fresh_ranges.length - 1
    range_b_idx = range_a_idx + 1
    did_merge = false

    while range_b_idx < fresh_ranges.length
        range_a = fresh_ranges[range_a_idx]
        range_b = fresh_ranges[range_b_idx]
        if does_range_overlap(range_a, range_b)
            range_a[:min] = (range_a[:min] < range_b[:min]) ? range_a[:min] : range_b[:min]
            range_a[:max] = (range_a[:max] > range_b[:max]) ? range_a[:max] : range_b[:max]
            fresh_ranges.delete_at(range_b_idx)
            did_merge = true
        else
            range_b_idx += 1
        end
    end

    # If there was a merge, iterate over range_a again, since the merge could cause previous ranges we checked to need to merge now
    # Example: (10 -> 14) vs. (16 -> 20) = no merge
    #          (10 -> 14) vs. (12 -> 18) = merge, but now we need to go back and check (10 -> 18) vs. (16 -> 20) again since they will merge
    if not did_merge
        range_a_idx += 1
    end
end

# Now that there are no overlapping ranges, we can just sum up (max - min + 1) for each range to get the total count of fresh ingredients
total_fresh_ingredient_count = 0
fresh_ranges.each do |range|
    total_fresh_ingredient_count += (range[:max] - range[:min]) + 1
end

puts "Part 2 Answer: #{total_fresh_ingredient_count}"