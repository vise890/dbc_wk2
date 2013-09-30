class Student

  attr_accessor :scores, :first_name
  attr_reader :ssn # not ideal

  def initialize(first_name, ssn, scores)

    scores.each do |score|
      raise ArgumentError.new('Invalid test score: #{score}') unless (0.0..100.0).include? score
    end
    raise ArgumentError.new('Invalid ssn: #{ssn}') unless ssn =~ /\d{3}.?\d{2}.?\d{4}/

    @first_name = first_name
    @scores = scores
    @ssn = ssn

  end

  def average
    @scores.reduce(:+) / @scores.size
  end

  def letter_grade
    case average
    when (0...60)
      'F'
    when (60...70)
      'D'
    when (70...80)
      'C'
    when (80...90)
      'B'
    when (90..100)
      'A'
    end
  end

end

## ADD YOUR CODE HERE and IN THE CLASS ABOVE

# 1. Create an array of 5 Students each with 5 test scores between 0 and 100.  
# The first Student should be named "Alex" with scores [100,100,100,0,100]
students = []
students << ['Alex', '111-11-1111', [100, 100, 100, 0, 100]]
students << ['Bob', '333-33-3333', [0, 40, 0, 0, 20]]
students << ['Jake', '222-22-2222', [10, 20, 30, 40, 50]]
students << ['Sally', '555-55-5555', [100, 95, 98, 100, 96]]
students << ['Peter', '444-44-4444', [65, 70, 65, 63, 78]]
students.map! { |student_data| Student.new(student_data[0], student_data[1], student_data[2]) }

# 2. Add average and letter_grade methods to the Student class.

# 3. Write a linear_search method that searches the student array for a student name
# and returns the position of that student if they are in the array.

def linear_search(students, match)

  match = students.map(&:first_name).index(match)
  match.nil? ? -1 : match

end

# 4. Add soring
def sort(students)
  students.sort_by! { |student| student.ssn }
end

# 5. Add binary search
def binary_search(students, target_ssn, low = 0, high = (students.count - 1))

  if high < low

    return -1

  else

    mid = ((low + high) / 2).floor

    if students[mid].ssn < target_ssn
      low = mid + 1
      binary_search(students, target_ssn, low, high)
    elsif students[mid].ssn > target_ssn
      high = mid - 1
      binary_search(students, target_ssn, low, high)
    else
      return mid
    end

  end

end

# =========== DRIVER CODE : DO NOT MODIFY =======

#Make sure these tests pass
# Tests for part 1:

p students[0].first_name == "Alex"
p students[0].scores.length == 5
p students[0].scores[0] == students[0].scores[4]
p students[0].scores[3] == 0


# Tests for part 2

p students[0].average == 80
p students[0].letter_grade == 'B'

# Tests for part 3

p linear_search(students, "Alex") == 0
p linear_search(students, "NOT A STUDENT") == -1

# Tests for part 4

sort(students)
p students[0].ssn < students[1].ssn
p students[3].ssn > students[0].ssn

# Tests for part 5
p binary_search(students, "111-11-1111") == 0
p binary_search(students, "000-00-0000") == -1
