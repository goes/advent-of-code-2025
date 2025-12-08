require "./day"

class Day06 < Day
  def parse_input
    lines = read_lines
    matrix = [read_operands(lines.pop)]
    lines.each { |line| matrix << parse_line(line, matrix.first) }
    @problems = matrix.transpose.map { |row| Problem.new(row) }
  end

  def solution_one
    @problems.collect(&:solution_1).sum
  end

  def solution_two
    @problems.collect(&:solution_2).sum
  end

  def parse_line(line, operands)
    result = []
    operands.collect { |h| h.last }.inject(0) do |pos, size|
      result << line[pos..pos + size - 1]
      pos + size + 1
    end
    result
  end

  def read_operands(line)
    line = line.gsub(/ \*/, "*").gsub(/ \+/, "+")
    # Hey Jonatan, ook een beetje naar fancy regexpen gezocht ;-)
    line.scan(/([*+])(\s*)/).collect { |char, spaces| [char, spaces.length + 1] }
  end
end

class Problem
  def initialize(arr)
    @operator = arr.first.first.to_sym
    @operands = arr[1..]
  end

  def solution_1
    @operands.collect(&:to_i).reduce(@operator)
  end

  def solution_2
    transposed_operands.reduce(@operator)
  end

  def transposed_operands
    digits = @operands.first.length
    (1..digits).collect { |i| @operands.map { |str| str[i - 1] }.reject(&:empty?).join.to_i }
  end
end

Day06.new.solve
