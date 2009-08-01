
module Pajamas
  module Commands
    module Tasks
      class Base
        def initialize(argv)
          @filename = "TODO"
          @filename = argv[0] if(argv.length>0)
        end
      end
    
      class List < Base
        def run
          @todoFile = TodoFile.read_file(@filename)
          @todoFile.save 
          puts @todoFile.to_console
        end
      end
      
      class Next < Base
        def run
          @todoFile = TodoFile.read_file(@filename)
          @todoFile.save
          puts @todoFile.current_to_console
          puts "\nMessage: #{@todoFile.current.message}\n"
        end
      end
      
     class Done < Base
        def run
          @todoFile = TodoFile.read_file(@filename)
          current = @todoFile.current
          current.done!
          @todoFile.save
          puts current.to_string
        end
      end
    end
  end  

end
