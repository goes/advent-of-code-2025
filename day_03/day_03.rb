require "./day"

class Day03 < Day
  def parse_input
    @banks = read_lines.map { |input| Bank.new(input) }
  end

  def solution_one = solution(2)

  def solution_two = solution(12)

  private

  def solution(weight)
    @banks.map { |bank| bank.max_joltage(weight) }.sum
  end
end

class Bank
  def initialize(str)
    @batteries = str.split("").map(&:to_i)
  end

  def max_joltage(weight)
    joltage, cursor = [], 0
    weight.times do
      min_pos, max_pos = cursor, (weight - joltage.length) * -1
      relevant_batteries = @batteries[min_pos..max_pos]
      joltage << relevant_batteries.max
      cursor += relevant_batteries.index(joltage.last) + 1
    end
    joltage.join.to_i
  end
end

Day03.new.solve
