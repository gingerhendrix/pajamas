
module Pajamas
  class Task
    attr_accessor :parent
    attr_accessor :children
    attr_accessor :description
    attr_accessor :done    
    
    def initialize(str)
      @str = str
      if @str.include?("+done")
        @description = @str.sub("+done", "").rstrip
        @done = true
      else
        @description = @str
        @done = false
      end
      @children = []
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
    
    def behaviours
      @str.scan(/@(\w*)/).flatten
    end
  end
end
