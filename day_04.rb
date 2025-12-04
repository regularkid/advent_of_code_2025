$grid = []

def init_grid()
    File.readlines("day_04_input.txt").each do |line|
        $grid.push([])
        line.strip.each_char do |c|
            $grid.last.push(c)
        end
    end
end

def is_grid_cell_paper_roll(x, y)
    if x < 0 or x >= $grid.first.length or y < 0 or y >= $grid.length
        return false
    end

    return $grid[y][x] == '@'
end

def get_num_paper_roll_neighbors(x, y)
    paper_roll_neighbor_count = 0

    for y_neighbor in (y - 1)..(y + 1)
        for x_neighbor in (x - 1)..(x + 1)
            if x_neighbor == x and y_neighbor == y
                next
            end

            if is_grid_cell_paper_roll(x_neighbor, y_neighbor)
                paper_roll_neighbor_count += 1
            end
        end
    end

    return paper_roll_neighbor_count
end

def get_accessible_paper_rolls_count(remove_accessible_rolls)
    accessible_paper_rolls = 0

    for y in 0..($grid.length - 1)
        for x in 0..($grid[y].length - 1)
            if is_grid_cell_paper_roll(x, y) and get_num_paper_roll_neighbors(x, y) < 4
                accessible_paper_rolls += 1

                if remove_accessible_rolls
                    $grid[y][x] = '.'
                end
            end
        end
    end

    return accessible_paper_rolls
end

init_grid()

# Part 1: Just count accessible rolls (but don't remove them)
puts "Part 1 Answer: #{get_accessible_paper_rolls_count(false)}"

# Part 2: Same as part 1, but remove accessible rolls each iteration and keep going until none are accessible anymore
total_paper_rolls_removed = 0
while true
    accessible_paper_rolls_count = get_accessible_paper_rolls_count(true)
    if accessible_paper_rolls_count == 0
        break
    end

    total_paper_rolls_removed += accessible_paper_rolls_count
end
puts "Part 2 Answer: #{total_paper_rolls_removed}"