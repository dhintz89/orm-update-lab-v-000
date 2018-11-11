require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  
  def initialize(id: nil, name:, :grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def save
    sql <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT id FROM students WHERE name=?",self.name)
  end
  
  def update(student)
    sql <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.new_from_db(row)
    Student.new(id: row[0], name: row[1], grade: row[3])
  end
  
  def self.find_by_name(name)
    sql <<-SQL
    SELECT * FROM students WHERE name=?
    SQL
    
    Students.new_from_db(DB[:conn].execute(sql, self.name))
  end

end
