require "./day"

class Day04 < Day
  def parse_input
    @map = Day04::Map.new(read_lines, directions: :all_directions)
  end

  def solution_one
    @map.locations.count(&:can_be_removed?)
  end

  def solution_two
    before = @map.locations.count(&:not_empty?)
    while @map.has_removable_roll?
      @map.remove_removable_rolls!
    end
    after = @map.locations.count(&:not_empty?)
    before - after
  end
end

class Day04::Location < Location
  def can_be_removed?
    return false if empty?

    neighbours.reject(&:empty?).size < 4
  end

  def remove_roll!
    self.value = @@empty_char
  end
end

class Day04::Map < Map
  @@location_class = Day04::Location

  def has_removable_roll?
    locations.any?(&:can_be_removed?)
  end

  def remove_removable_rolls!
    locations.each do |location|
      location.remove_roll! if location.can_be_removed?
    end
  end
end

Day04.new.solve
