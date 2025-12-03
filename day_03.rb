def calculate_joltage_sum(num_joltage_digits)
    joltage_sum = 0

    File.readlines("day_03_input.txt").each do |bank|
        # Remove whitespace so that string length only counts the digits
        bank = bank.strip

        # Keep track of bank digit indices as we build up the max joltage value
        joltage_digit_bank_indices = []

        # For each joltage digit, search bank for next highest digit
        for joltage_digit_idx in 0..(num_joltage_digits - 1)
            # Add a new joltage digit
            joltage_digit_bank_indices.push(-1)

            # Only search part of the bank:
            #     Start from the next bank digit after the last joltage digit we found.
            #     End at (bank length - joltage digits remaining). This ensures that we leave enough bank digits for the full number of joltage digits.
            num_joltage_digits_remaining = num_joltage_digits - joltage_digit_idx
            for bank_index in (joltage_digit_bank_indices[joltage_digit_idx - 1] + 1)..(bank.length - num_joltage_digits_remaining) do
                if joltage_digit_bank_indices[joltage_digit_idx] == -1 or bank[bank_index] > bank[joltage_digit_bank_indices[joltage_digit_idx]]
                    joltage_digit_bank_indices[joltage_digit_idx] = bank_index
                end
            end
        end

        # Build up the final joltage value by joining together all of the bank digits we found above
        largest_joltage = ""
        for bank_idx in joltage_digit_bank_indices
            largest_joltage += bank[bank_idx]
        end

        # Add this joltage value to the running sum
        joltage_sum += largest_joltage.to_i
    end

    return joltage_sum
end

puts "Part 1 Answer: #{calculate_joltage_sum(2)}"
puts "Part 2 Answer: #{calculate_joltage_sum(12)}"