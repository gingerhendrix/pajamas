
module Pajamas
  class TodoFile
    attr_accessor :items
  
    def initialize
      @items = []
    end
    
    def self.read_string(todo_string)
      todo = TodoFile.new
      todo_string.each_line do |todo_line|
        todo.items << todo_line.chomp
      end
      todo
    end
    
    def self.read_file(filename)
      read_string File.read(filename)
    end
    
    def to_console
       @items.join("\n")
    end
    
    
  
  end
end
