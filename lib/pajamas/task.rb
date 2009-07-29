
module Pajamas
  class Task
    attr_accessor :parent
    attr_accessor :children
    attr_accessor :description
    attr_accessor :done    
    
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
    end
    
    def children
      if @children.empty?
        behaviours.each do |b|
          @children = @children + b.generated_substeps
        end
      end
      @children
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
    
    def done?
      @done
    end
    
    def done!
      @done = true
    end
    
    def to_string
      if done
        @description + " +done"
      else
        @description
      end
    end
    
    def behaviour_names
      @str.scan(/@(\w*)/).flatten
    end
    
    def behaviours
      behaviour_names.map { |b| 
        clazz_name = "#{b}_behaviour".classify
        clazz = "Pajamas::Behaviours::#{clazz_name}".constantize rescue nil
        clazz ? clazz.new(self) : nil
      }.compact
    end
  end
end
