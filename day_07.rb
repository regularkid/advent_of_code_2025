# Part 1
rows = []
File.readlines("day_07_input.txt").each do |line|
    rows.push(line.strip)
end

num_splits = 0
for row_idx in 1..(rows.length - 1)
    for col_idx in 0..(rows[row_idx].length - 1)
        grid_value = rows[row_idx][col_idx]
        grid_value_above = rows[row_idx - 1][col_idx]
        if grid_value == '^' and grid_value_above == '|'
            if col_idx > 0
                rows[row_idx][col_idx - 1] = '|'
            end
            if col_idx < rows[0].length - 1
                rows[row_idx][col_idx + 1] = '|'
            end
            num_splits += 1
        elsif grid_value_above == 'S' or grid_value_above == '|'
            rows[row_idx][col_idx] = '|'
        end
    end
end

puts "Part 1 Answer: #{num_splits}"

# Part 2 - Recursion + memoization
rows = []
File.readlines("day_07_input.txt").each do |line|
    rows.push(line.strip)
end

start_row_idx = 1
start_col_idx = -1
for col_idx in 0..(rows[0].length - 1)
    if rows[0][col_idx] == 'S'
        start_col_idx = col_idx
        break
    end
end

memoize = {}

def do_particle_movement(rows, col_idx, row_idx, memoize)
    if row_idx == rows.length - 1
        return 1
    end

    memoize_key = row_idx.to_s + "-" + col_idx.to_s
    if memoize[memoize_key] != nil
        return memoize[memoize_key]
    end

    result = 0
    if rows[row_idx + 1][col_idx] == '^'
        left_count = 0
        right_count = 0
        if col_idx > 0
            left_count = do_particle_movement(rows, col_idx - 1, row_idx + 1, memoize)
        end
        if col_idx < rows[0].length - 1
            right_count = do_particle_movement(rows, col_idx + 1, row_idx + 1, memoize)
        end

        result = left_count + right_count
    else
        result = do_particle_movement(rows, col_idx, row_idx + 1, memoize)
    end

    memoize[memoize_key] = result
    return result
end

num_timelines = do_particle_movement(rows, start_col_idx, start_row_idx, memoize)

puts "Part 2 Answer: #{num_timelines}"