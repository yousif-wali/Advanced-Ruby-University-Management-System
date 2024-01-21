# Abstract class for common attributes and behaviors
class Person
  attr_reader :name, :id

  def initialize(name, id)
    @name = name
    @id = id
  end
end

# Module for enrollment functionalities
module Enrollable
  def enroll(course)
    raise "Capacity full" if course.full?

    course.add_student(self)
  end
end

# Student class
class Student < Person
  include Enrollable

  def initialize(name, id, major)
    super(name, id)
    @major = major
  end

  def display
    puts "Student: #{@name}, ID: #{@id}, Major: #{@major}"
  end
end

# Professor class
class Professor < Person
  def initialize(name, id, department)
    super(name, id)
    @department = department
  end

  def assign_course(course)
    course.professor = self
  end

  def display
    puts "Professor: #{@name}, ID: #{@id}, Department: #{@department}"
  end
end

# Course class
class Course
  attr_accessor :professor
  attr_reader :name, :id, :capacity, :students

  def initialize(name, id, capacity)
    @name = name
    @id = id
    @capacity = capacity
    @students = []
  end

  def add_student(student)
    @students << student
  end

  def full?
    @students.size >= @capacity
  end

  def display
    puts "Course: #{@name}, ID: #{@id}, Professor: #{@professor&.name}"
    puts "Enrolled students:"
    @students.each { |student| puts " - #{student.name}" }
  end
end

# Department class with management functionalities
class Department
  include Manageable

  def initialize(name)
    @name = name
    @courses = []
    @professors = []
  end

  def add_course(course)
    @courses << course
  end

  def add_professor(professor)
    @professors << professor
  end

  def manage
    puts "Managing Department: #{@name}"
    @courses.each(&:display)
    @professors.each(&:display)
  end
end

# Example usage
begin
  math_dept = Department.new("Mathematics")
  prof_john = Professor.new("John", 1001, "Mathematics")
  course_calculus = Course.new("Calculus", 2001, 2)
  student_alice = Student.new("Alice", 3001, "Mathematics")
  student_bob = Student.new("Bob", 3002, "Mathematics")

  math_dept.add_course(course_calculus)
  math_dept.add_professor(prof_john)
  prof_john.assign_course(course_calculus)
  student_alice.enroll(course_calculus)
  student_bob.enroll(course_calculus)

  math_dept.manage
rescue StandardError => e
  puts "Error: #{e.message}"
end
