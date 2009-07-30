
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
        if !todo_line.strip.empty? 
          indent = todo_line.match(/^ */)[0].length / 2
          previous_task = task
          task = Task.new(todo_line.strip)
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
      end
      todo
    end
    
    def current
      current = nil
      roots.detect { |root| current = root.find_deep { |t| !t.done? } if current.nil? }
      current
    end
    
    def self.read_file(filename)
      todo = self.read_string(File.read(filename))
      todo.filename = filename
      todo
    end
    
    def to_console
      indent = "  "
      lines = []
      @roots.each do |root|
        lines += root.depth_visit { |node, depth| (indent*depth) + node.to_string }
      end
      lines.join("\n") + "\n"
    end
    
    def to_file
       to_console
    end
    
    def save(filename=nil)
      filename = @filename if !filename
      raise StandardError.new "No filename supplied to save" if !filename
      file = File.new(filename, "w")
      file.write(self.to_file)
    end
    
    def current_to_console
      context = []
      context.unshift current.to_string
      parent = current
      while(parent = parent.parent)
        context.unshift parent.to_string      
      end
      indent = ""
      context.map{ |c| out = "#{indent}#{c}"; indent = indent + "  "; out  }.join("\n")
    end
  
  end
end
