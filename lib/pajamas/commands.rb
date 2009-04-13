
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
          puts @todoFile.to_console
        end
      end
      
      class Next < Base
        def run
          @todoFile = TodoFile.read_file(@filename)
          puts @todoFile.current_to_console
        end
      end
    end
  end  

end
