module Pajamas
  module Behaviours
    class TddBehaviour
      attr_accessor :task

      def initialize(task)
        @task = task
      end
      
      def generated_substeps
        [Task.new("Write failing test"), 
         Task.new("Write code to make test pass")]
      end
    end
  end
end
