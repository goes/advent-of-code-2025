require "./day"

class Day07 < Day
  def parse_input
    @map = Day07::Map.new(read_lines)
  end

  def solution_one
    @map.split_count_after_beaming
  end

  def solution_two
    @map.nr_of_distinct_beams
  end
end

class Day07::Location < Location
  def should_beam?
    return false if empty?

    starter? || beam?
  end

  def beam!
    # puts @map  # show the beaming progress
    if neighbour_down.empty?
      neighbour_down.value = "|"
      false
    elsif neighbour_down.splitter?
      neighbour_down.neighbour_left.value = "|"
      neighbour_down.neighbour_right.value = "|"
      true
    end
  end

  def splitter? = value == "^"

  def starter? = value == "S"

  def beam? = value == "|"
end

class Day07::Map < Map
  @@location_class = Day07::Location

  def split_count_after_beaming
    split_count = 0
    @matrix[..-2].each do |row|
      row.each do |location|
        next unless location.should_beam?
        splitted = location.beam!
        split_count += 1 if splitted
      end
    end
    split_count
  end

  def nr_of_distinct_beams
    nr_of_beams(locations.detect(&:starter?), {})
  end

  def nr_of_beams(location, cache)
    return 1 if !location.neighbour_down # we zijn op 't einde
    return cache[location] if cache.key?(location)

    result = if location.splitter?
        left = nr_of_beams(location.neighbour_down.neighbour_left, cache)
        right = nr_of_beams(location.neighbour_down.neighbour_right, cache)
        left + right
      elsif location.empty? || location.starter?
        nr_of_beams(location.neighbour_down, cache)
      else
        0
      end

    cache.merge!({ location => result })
    result
  end
end

Day07.new.solve
