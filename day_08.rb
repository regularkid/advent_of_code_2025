JunctionBox = Struct.new(:x, :y, :z, :circuit)
JunctionBoxPair = Struct.new(:box_a, :box_b, :distance)
Circuit = Struct.new(:boxes)

# Read in junction boxes
junction_boxes = []
File.readlines("day_08_input.txt").each do |line|
    position_values = line.strip.split(',')
    junction_boxes.push(JunctionBox.new(position_values[0].to_f, position_values[1].to_f, position_values[2].to_f))
end

# Build list of all junction box pairs and their distance to each other
junction_box_pairs = []
for box_a_idx in 0..(junction_boxes.length - 1)
    for box_b_idx in (box_a_idx + 1)..(junction_boxes.length - 1)
        box_a = junction_boxes[box_a_idx]
        box_b = junction_boxes[box_b_idx]
        distance = Math.sqrt((box_a.x - box_b.x).abs2 + (box_a.y - box_b.y).abs2 + (box_a.z - box_b.z).abs2)
        junction_box_pairs.push(JunctionBoxPair.new(box_a, box_b, distance))
    end
end

# Sort junction pairs by distance
junction_box_pairs_sorted = junction_box_pairs.sort_by { |pair| pair.distance}

# Build circuits
circuits = []
for i in 0..999
    if i >= junction_box_pairs_sorted.length
        break
    end

    pair = junction_box_pairs_sorted[i]

    # New circuit?
    if pair.box_a.circuit == nil and pair.box_b.circuit == nil
        circuit = Circuit.new(:boxes)
        circuit.boxes = []
        circuit.boxes.push(pair.box_a)
        circuit.boxes.push(pair.box_b)
        pair.box_a.circuit = circuit
        pair.box_b.circuit = circuit
        circuits.push(circuit)
    # Ignore boxes already on the same circuit
    elsif pair.box_a.circuit == pair.box_b.circuit
        next
    # Add new box to an existing circuit?
    elsif pair.box_a.circuit != nil and pair.box_b.circuit == nil
        pair.box_a.circuit.boxes.push(pair.box_b)
        pair.box_b.circuit = pair.box_a.circuit
    elsif pair.box_b.circuit != nil and pair.box_a.circuit == nil
        pair.box_b.circuit.boxes.push(pair.box_a)
        pair.box_a.circuit = pair.box_b.circuit
    # Combine two existing circuits?
    elsif pair.box_a.circuit != nil and pair.box_b.circuit != nil and pair.box_a.circuit != pair.box_b.circuit
        circuit_to_delete = pair.box_b.circuit
        pair.box_b.circuit.boxes.each do |box|
            pair.box_a.circuit.boxes.push(box)
            box.circuit = pair.box_a.circuit
        end
        circuits.delete(circuit_to_delete)
    end
end

# Sort circuits by number of junction boxes (descending)
circuits_sorted = circuits.sort_by { |circuit| circuit.boxes.length }.reverse

# Answer is size of 3 largest circuits multiplied together
part_1_answer = circuits_sorted[0].boxes.length * circuits_sorted[1].boxes.length * circuits_sorted[2].boxes.length
puts "Part 1 Answer: #{part_1_answer}"

# Part 2: Continue until we have only a single circuit
cur_idx = 1000
while cur_idx < junction_box_pairs_sorted.length
    pair = junction_box_pairs_sorted[cur_idx]
    cur_idx += 1

    # New circuit?
    if pair.box_a.circuit == nil and pair.box_b.circuit == nil
        circuit = Circuit.new(:boxes)
        circuit.boxes = []
        circuit.boxes.push(pair.box_a)
        circuit.boxes.push(pair.box_b)
        pair.box_a.circuit = circuit
        pair.box_b.circuit = circuit
        circuits.push(circuit)
    # Ignore boxes already on the same circuit
    elsif pair.box_a.circuit == pair.box_b.circuit
        next
    # Add new box to an existing circuit?
    elsif pair.box_a.circuit != nil and pair.box_b.circuit == nil
        pair.box_a.circuit.boxes.push(pair.box_b)
        pair.box_b.circuit = pair.box_a.circuit
    elsif pair.box_b.circuit != nil and pair.box_a.circuit == nil
        pair.box_b.circuit.boxes.push(pair.box_a)
        pair.box_a.circuit = pair.box_b.circuit
    # Combine two existing circuits?
    elsif pair.box_a.circuit != nil and pair.box_b.circuit != nil and pair.box_a.circuit != pair.box_b.circuit
        circuit_to_delete = pair.box_b.circuit
        pair.box_b.circuit.boxes.each do |box|
            pair.box_a.circuit.boxes.push(box)
            box.circuit = pair.box_a.circuit
        end
        circuits.delete(circuit_to_delete)
    end

    if circuits.length == 1 and circuits[0].boxes.length == junction_boxes.length
        part_2_answer = pair.box_a.x * pair.box_b.x
        puts "Part 2 Answer: #{part_2_answer}"
        break
    end
end