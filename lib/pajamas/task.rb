
module Pajamas
  class Task
    attr_accessor :parent
    attr_accessor :children
    attr_accessor :description
    attr_accessor :done    
    attr_accessor :behaviours
    
    def initialize(str, parent=nil)
      @str = str
      if @str.include?("+done")
        @description = @str.sub("+done", "").rstrip
        @done = true
      else
        @description = @str
        @done = false
      end
      @parent = parent
      @children = []
      @behaviours = generate_behaviours
      generate_children
    end
    
    def generate_children
      behaviours.each do |b|
         if !b.done?
            @children = @children + b.generated_substeps            
            b.done = true
         end
      end
    end
    
    def generate_behaviours
      behaviour_names.map { |b| 
        if b.include? '!'
          b = b.gsub(/!/, "")
          d = true
        end
        clazz_name = "#{b}_behaviour".classify
        clazz = "Pajamas::Behaviours::#{clazz_name}".constantize rescue nil
        obj = clazz ? clazz.new(self) : nil
        obj.done = d if obj
        obj
      }.compact
    end
    
    def find_deep(&selector)
      result = selector.call(self)
      if result
        child_result = nil
        children.each { |c| child_result = c.find_deep &selector if child_result.nil? }
        child_result.nil? ? self : child_result 
      else
       nil
      end
    end
    
    def depth_visit(start=0, &block)
      out = [block.call(self, start)] + children.map { |c| c.depth_visit start+1, &block }.flatten
    end
    
    def done?
      @done
    end
    
    def done!
      @done = true
    end
    
    def to_string
      line = @description
      line += " +done" if done?
      behaviours.each do |b|
        line.gsub!(/@#{b.name}(!)*/, "@#{b.name}!")
      end
      line
    end
    
    def behaviour_names
      @str.scan(/@(\w*(?:!)?)/).flatten
    end
  
  end
end
