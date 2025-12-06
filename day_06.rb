values = []

# Read in problems. Separate array for each problem row (last row is the operation). Column index maps to a specific problem.
File.readlines("day_06_input.txt").each do |line|
    values.push([])

    line.strip.split(/\s+/).each do |value|
        values.last.push(value)
    end
end

operation_idx = values.length - 1
max_value_idx = values.length - 2

# Calculate each problem + total sum
total_sum = 0
for problem_idx in 0..values.first.length
    # What operation are we doing?
    operation = values[operation_idx][problem_idx]

    # Start with the first value
    result = values[0][problem_idx].to_i

    # Add or multiply the rest of the values into the result
    for value_idx in 1..max_value_idx
        if operation == '+'
            result += values[value_idx][problem_idx].to_i
        else
            result *= values[value_idx][problem_idx].to_i
        end
    end

    total_sum += result.to_i
end

puts "Part 1 Answer: #{total_sum}"

# Part 2: Read columns vertically
columns = []
max_num_columns = 0
File.readlines("day_06_input.txt").each do |line|
    columns.push(line.delete("\n"))
    max_num_columns = (columns.last.length > max_num_columns) ? columns.last.length : max_num_columns
end

operation_idx = columns.length - 1

# Calculate each problem, reset whenever we hit a new operation in the last row
running_values = []
running_operation = ''
total_sum = 0
for column_idx in 0..(max_num_columns - 1)
    operation_row_value = columns[operation_idx][column_idx]
    
    # Start of a new operation?
    if operation_row_value != ' '
        # Finish the current/running operation and add it to the sum
        if running_values.length != 0
            result = running_values[0]

            # Add or multiply the rest of the values into the result
            for value_idx in 1..(running_values.length - 1)
                if running_operation == '+'
                    result += running_values[value_idx]
                else
                    result *= running_values[value_idx]
                end
            end

            total_sum += result
        end

        # Reset for the next operation
        running_values = []
        running_operation = operation_row_value
    end

    # Add a new value to the current operation
    value = 0
    for row_idx in 0..(columns.length - 2)
        digit = columns[row_idx][column_idx].to_i
        if digit != 0
            value *= 10
            value += digit
        end
    end

    if value != 0
        running_values.push(value)
    end
end

# Last operation needs to be calculated (ugly, should do it in the loop)
result = running_values[0]
for value_idx in 1..(running_values.length - 1)
    if running_operation == '+'
        result += running_values[value_idx]
    else
        result *= running_values[value_idx]
    end
end
total_sum += result

puts "Part 2 Answer: #{total_sum}"