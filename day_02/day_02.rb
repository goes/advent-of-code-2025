require "./day"

class Day02 < Day
  def parse_input
    @input_ranges = read_lines.first.split(",")
  end

  def solution_one
    solution(IDRange)
  end

  def solution_two
    solution(IDRange2)
  end

  private

  def solution(range_klass)
    ranges = @input_ranges.map { |it| range_klass.new(it) }
    ranges.flat_map { |r| r.invalid_ids }.sum
  end
end

class IDRange
  def initialize(str)
    @id_1, @id_2 = str.split("-").map(&:to_i)
  end

  def invalid_ids
    (@id_1..@id_2).each.inject([]) do |arr, id|
      arr << id unless valid? (id)
      arr
    end
  end

  private

  def valid?(id)
    parts = split_number(id, 2)
    return true if parts.empty?

    parts.first != parts.last
  end

  def split_number(num, number_of_sections)
    s = num.to_s
    return [] if s.length % number_of_sections != 0

    section_length = s.length / number_of_sections

    (0...number_of_sections).map do |i|
      start_index = i * section_length
      s[start_index, section_length]
    end
  end
end

class IDRange2 < IDRange
  private

  def valid?(id)
    (1..id.to_s.length).each do |i|
      parts = split_number(id, i)
      return false if parts.length > 1 && parts.uniq.length == 1
    end
    return true
  end
end

Day02.new.solve
