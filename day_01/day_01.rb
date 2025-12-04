require "./day"

class Day01 < Day
  def parse_input
    lines = read_lines
    @rotations = lines
      .collect { |line| line.match(/^([A-Za-z]+)(\d+)$/) }
      .map { |match| [match[1], match[2].to_i] }
  end

  def solution_one
    score(Dial01.new(50))
  end

  def solution_two
    score(Dial02.new(50))
  end

  private

  def score(dial)
    @rotations.sum { |direction, distance| dial.rotation_score(direction, distance) }
  end
end

class Dial01
  OPERATIONS = { "L" => :-, "R" => :+ }

  def initialize(position)
    @position = position
  end

  def rotate(direction, distance)
    @position = @position.send(OPERATIONS[direction], distance) % 100
  end

  def rotation_score(direction, distance)
    rotate(direction, distance)
    @position.zero? ? 1 : 0
  end
end

class Dial02 < Dial01
  def rotation_score(direction, distance)
    score = 0
    distance.times { score += super(direction, 1) }
    score
  end
end

Day01.new.solve
