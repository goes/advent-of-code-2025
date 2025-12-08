require "./day"

class Day08 < Day
  def parse_input
    junction_boxes = read_lines.collect { |line| JunctionBox.new(*line.split(",").map(&:to_i)) }
    @space = Space.new(junction_boxes)
  end

  def solution_one
    @space.tap { |space| space.connect(mode == :test ? 10 : 1000) }.circuit_value(3)
  end

  def solution_two
    @space.connect_into_one_circuit
  end
end

class JunctionBox
  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def distance_to(other)
    Math.sqrt((@x - other.x) ** 2 + (@y - other.y) ** 2 + (@z - other.z) ** 2)
  end
end

class Circuit
  attr_reader :junction_boxes

  def initialize
    @junction_boxes = []
  end

  def add_junction_box(junction_box)
    @junction_boxes << junction_box
  end

  def length
    @junction_boxes.length
  end
end

class Space
  attr_reader :junction_boxes, :circuits, :distances

  def initialize(junction_boxes)
    @junction_boxes = junction_boxes
    @circuits = junction_boxes.collect { |jb| Circuit.new.tap { |circuit| circuit.add_junction_box(jb) } }
    @distances = calculate_distances
  end

  def calculate_distances
    distances = {}
    @junction_boxes.each_with_index do |jb1, i|
      @junction_boxes.each_with_index do |jb2, j|
        next if i == j
        key = [i, j].sort
        distances[key] = jb1.distance_to(jb2)
      end
    end
    distances.sort_by { |_, distance| distance }
  end

  def circuit_value(n)
    circuits = @circuits.sort_by(&:length).last(n)
    circuits.map(&:length).reduce(&:*)
  end

  def connect(n)
    @distances.take(n).each do |(i, j), _distance|
      jb1, jb2 = @junction_boxes[i], @junction_boxes[j]
      circuitize(jb1, jb2)
    end
  end

  def connect_into_one_circuit
    i = 0
    while @circuits.size > 1
      distance = @distances[i]
      jb1, jb2 = @junction_boxes[distance.first.first], @junction_boxes[distance.first.last]
      last_boxes = [jb1, jb2]

      circuitize(jb1, jb2)
      i += 1
    end
    last_boxes.collect(&:x).reduce(:*)
  end

  private

  def find_circuit_for(junction_box)
    @circuits.find { |circuit| circuit.junction_boxes.include?(junction_box) }
  end

  def merge_circuits(circuit1, circuit2)
    circuit1.junction_boxes.concat(circuit2.junction_boxes)
    @circuits.delete(circuit2)
  end

  def circuitize(jb1, jb2)
    circuit1 = find_circuit_for(jb1)
    circuit2 = find_circuit_for(jb2)

    if circuit1 && circuit2
      if circuit1 != circuit2
        merge_circuits(circuit1, circuit2)
      end
    elsif circuit1
      circuit1.add_junction_box(jb2)
    elsif circuit2
      circuit2.add_junction_box(jb1)
    else
      circuit = Circuit.new
      circuit.add_junction_box(jb1)
      circuit.add_junction_box(jb2)
      @circuits << circuit
    end
  end
end

Day08.new.solve
