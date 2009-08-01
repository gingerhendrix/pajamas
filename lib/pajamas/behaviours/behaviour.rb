module Pajamas
  module Behaviours
    class Behaviour
      attr_accessor :task
      attr_accessor :done
      
      def initialize(task)
        @task = task
      end
      
      def name
        self.class.name.demodulize.underscore.gsub(/_behaviour$/, '')
      end
      
      def done?
        !!@done
      end
      
      def generated_substeps
        []
      end
      
      def message
        nil
      end
    end
  end
end
