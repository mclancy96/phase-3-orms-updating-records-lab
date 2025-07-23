require_relative '../config/environment'
require 'pry'

class Student
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    id ? update : insert
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students;
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    new_student = new(name, grade)
    new_student.save
  end

  private

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, [name, grade, id])
  end

  def insert
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, [name, grade])
    self.id = DB[:conn].last_insert_row_id
  end
end
