
module Pajamas
  class Task
    attr_accessor :parent
    attr_accessor :children
    
    def initialize(str)
      @str = str
      @children = []
    end
    
    def done?
      @str.include?("+done")
    end
    
    def to_string
      @str
    end
  end
end
