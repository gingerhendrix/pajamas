module Pajamas
  module Behaviours
    class TddBehaviour
      attr_accessor :task

      def initialize(task)
        @task = task
      end
      
      def generated_substeps
        [Task.new("Write failing test", @task), 
         Task.new("Write code to make test pass", @task)]
      end
    end
  end
end
