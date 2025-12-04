require "debug"
require "benchmark"

class Day
  attr_accessor :mode, :day

  def initialize
    self.day = self.class.name.match(/(\d+)$/)[1].to_i
    self.mode = :test
    reset
  end

  def reset
  end

  def parse_input
    raise NotImplementedError
  end

  def solve
    { 1 => :solution_one, 2 => :solution_two }.each do |idx, selector|
      solutions = %i[test real].collect do |mode|
        self.mode = mode
        reset
        parse_input
        send(selector)
      end

      puts "Dag #{@day}, deel #{idx}: #{solutions.join(", ")}"
    end
  end

  def file_name
    fn = ("#{__dir__}/day_%02d/input_#{mode}.txt" % self.day)
    return fn if File.exist?(fn)

    "./input/day_%02d_#{mode == :test ? 1 : 2}.txt" % self.day
  end

  def read_lines
    File.readlines(file_name).collect(&:strip)
  end

  def log(string)
    puts "#{Time.now} :: #{string}"
  end
end

class Location
  @@empty_char = "."
  attr_accessor :value

  def initialize(value, x, y, map)
    @value = value
    @x = x
    @y = y
    @map = map
  end

  def empty?
    @value == @@empty_char
  end

  def not_empty?
    !empty?
  end

  def neighbours
    @map.neighbours(@x, @y)
  end
end

class Map
  @@location_class = Location

  attr_accessor :directions

  def initialize(rows, directions: :primary_directions)
    @matrix = rows.map.with_index do |row, y|
      row.chars.map.with_index { |c, x| @@location_class.new(c, x, y, self) }
    end
    @directions = directions
  end

  def [](x, y)
    @matrix[y][x] if valid?(x, y)
  end

  def update(x, y, value)
    @matrix[y][x].value = value if valid?(x, y)
  end

  def neighbours(x, y)
    case @directions
    when :primary_directions
      [[0, -1], [0, 1], [-1, 0], [1, 0]]
    when :secondary_directions
      [[-1, -1], [1, -1], [-1, 1], [1, 1]]
    when :all_directions
      [[0, -1], [0, 1], [-1, 0], [1, 0], [-1, -1], [1, -1], [-1, 1], [1, 1]]
    else []
    end.map { |dx, dy| [x + dx, y + dy] }
       .select { |nx, ny| valid?(nx, ny) }
       .map { |nx, ny| self[nx, ny] }
  end

  def locations
    @matrix.flatten
  end

  private

  def valid?(x, y)
    y.between?(0, @matrix.size - 1) && x.between?(0, @matrix[y].size - 1)
  end
end
