require "./day"

class Day05 < Day
  def parse_input
    lines = read_lines
    split_at = lines.index ""
    @ingredient_ranges = lines[0..split_at - 1].map { |line| IngredientRange.new(*line.split("-").collect(&:to_i)) }
    @ingredients = lines[split_at + 1..].collect(&:to_i)
  end

  def solution_one
    @ingredients.count { |ingredient| @ingredient_ranges.any? { |range| range.contains?(ingredient) } }
  end

  def solution_two
    @ingredient_ranges
      .map(&:range)
      .reduce([]) { |result, range| result = add_interval(result, range) }
      .sum { |range| range.end - range.begin + 1 }
  end

  def add_interval(ranges, new_range)
    sorted_ranges = (ranges + [new_range]).sort_by(&:begin)
    sorted_ranges.reduce([]) do |result, current|
      if result.empty?
        result << current
      else
        last_range = result.last
        if last_range.end >= current.begin - 1
          new_end = [last_range.end, current.end].max
          result[-1] = (last_range.begin..new_end)
        else
          result << current
        end
      end
      result
    end
  end
end

class IngredientRange
  attr_reader :first, :last

  def initialize(first, last)
    @first = first
    @last = last
  end

  def range
    (first..last)
  end

  def contains?(ingredient)
    @first <= ingredient && ingredient <= @last
  end
end

Day05.new.solve
