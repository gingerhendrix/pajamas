module Pajamas
  module Behaviours
    class TddBehaviour < Behaviour
      
      def generated_substeps
        [Task.new("Write failing test", @task), 
         Task.new("Write code to make test pass", @task)]
      end
    end
  end
end
