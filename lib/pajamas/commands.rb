
module Pajamas
  module Commands
    module Tasks
      class List
        
        def initialize(argv)
          @filename = "TODO"
          @filename = argv[0] if(argv.length>0)
        end
        
        def run
          @todoFile = TodoFile.read_file(@filename)
          puts @todoFile.to_console
        end
      end
    end
  end  

end
