
module Pajamas
  class TodoFile
    attr_accessor :items
    attr_accessor :roots
    attr_accessor :filename
  
    def initialize
      @items = []
      @roots = []
    end
    
    def self.read_string(todo_string)
      todo = TodoFile.new
      current_indent = 0
      task = nil
      todo_string.each_line do |todo_line|
        indent = todo_line.match(/^ */)[0].length / 2
        previous_task = task
        task = Task.new(todo_line.chomp)
        if indent==0 || !previous_task
          todo.roots << task
        elsif indent==current_indent
          previous_task.parent.children << task
          task.parent = previous_task.parent
        elsif indent>current_indent
          previous_task.children << task
          task.parent = previous_task
        elsif indent<current_indent
          parent = previous_task.parent
          (current_indent - indent).times do 
            parent = parent.parent
          end
          parent.children << task
          task.parent = parent
        end
        current_indent = indent
        todo.items << task
      end
      todo
    end
    
    def current
      i = 0
      cur = nil
      while cur.nil? && i < roots.length do
        root = roots[i]
        cur = current_from_root(root)
        i = i+1
      end
      cur
    end
    
    def current_from_root(root)
      if !root.done? 
        cur = nil
        root.children.each do |child|
          cur = current_from_root(child)
        end
        return cur || root
      end
      return nil    
    end
    
    def self.read_file(filename)
      todo = self.read_string(File.read(filename))
      todo.filename = filename
      todo
    end
    
    def to_console
       @items.map(&:to_string).join("\n")
    end
    
    def to_file
      @items.map(&:to_string).join("\n")
    end
    
    def save(filename=nil)
      filename = @filename if !filename
      raise StandardError.new "No filename supplied to save" if !filename
      file = File.new(filename, "w")
      file.write(self.to_file)
    end
    
    def current_to_console
      context = []
      context.unshift current
      parent = current
      while(parent = parent.parent)
        context.unshift parent      
      end
      context.map(&:to_string).join("\n")
    end
  
  end
end
