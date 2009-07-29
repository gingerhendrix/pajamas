require File.dirname(__FILE__) + '/../../spec_helper'

include Pajamas

describe "TddBehaviour" do
  
  describe "initialize" do
    it "should take have a task" do
      @behave = Behaviours::TddBehaviour.new :task
      @behave.task.should == :task
    end
  end
  
  describe "generated_substeps" do
  
    it "should create two substep tasks - 'Write failing test' and 'Write code to make test pass'" do
      @behave = Behaviours::TddBehaviour.new :task
      task1 = mock("task1")
      task2 = mock("task1")
      
      Task.should_receive(:new).with('Write failing test', :task).and_return(task1)
      Task.should_receive(:new).with('Write code to make test pass', :task).and_return(task2)
      @behave.generated_substeps.should == [task1, task2]     
    end
  end

end
