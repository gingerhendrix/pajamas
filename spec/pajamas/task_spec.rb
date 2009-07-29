require File.dirname(__FILE__) + '/../spec_helper'

module Pajamas  
  module Behaviours
    class BehaviourBehaviour; def initialize(t); end; end;
    class OtherBehaviourBehaviour; def initialize(t); end; end;
  end
end

describe "Task" do
  
  describe "initialize" do
    it "should have default state" do 
      @task = Pajamas::Task.new "Some Task"
      @task.parent.should == nil
      @task.children.should == []
      @task.to_string.should == "Some Task"
    end
    
    it "should have an optional parent argument" do
      @task = Pajamas::Task.new "Some Task", :parent
      @task.parent.should == :parent
    end
  end
  
  describe "done?" do
    it "should be true if description contains +done" do
      @task = Pajamas::Task.new "Some Task +done"
      @task.should be_done
    end
    
    it "should be false if description does not contain +done" do
      @task = Pajamas::Task.new "Some Task"
      @task.should_not be_done    
    end
  
  end
  
  describe "find_deep" do
  
    before do
      @task = Pajamas::Task.new "Some Task"
    end
  
    it "should return nil, if it doesn't match the selector" do
      @task.find_deep { |t| false }.should == nil
    end
    
    it "should return itself, it it does match the selector and has no children" do
      @task.should_receive(:children).and_return([])
      @task.find_deep { |t| true }.should == @task
    end
    
    it "should recurse on its children, and return the first with a match" do
      child1 = mock("child1")
      child1.should_receive(:find_deep).and_return(nil)
      child2 = mock("child2")
      child2.should_receive(:find_deep).and_return(:result)
      child3 = mock("child3")
      child3.should_not_receive(:find_deep)

      @task.should_receive(:children).and_return([child1, child2, child3])
      @task.find_deep { |t| true }.should == :result
    end
  
  end
  
  describe "done!" do
    it "should set the task to done" do
      @task = Pajamas::Task.new "Some Task"
      @task.done!
      @task.should be_done
    end
  end
  
  describe "description" do
    it "should be the description" do
      @task = Pajamas::Task.new "Some Task"
      @task.description.should == "Some Task"
    end
  
    it "should not contain the status" do
      @task = Pajamas::Task.new "Some Task +done"
      @task.description.should == "Some Task"
    end
  
  end
  
  describe "to_string" do
    it "should be the description if !done" do
      @task = Pajamas::Task.new "Some Task"
      @task.to_string.should == "Some Task"
    end
    
    it "should be the description +done if done" do
      @task = Pajamas::Task.new "Some Task"
      @task.done!
      @task.to_string.should == "Some Task +done"
    end
  end
  
  describe "behaviour_names" do
    it "should contain the @keywords" do
      @task = Pajamas::Task.new "@behaviour Some Task "
      @task.behaviour_names.should == ['behaviour']
    end
    
    it "should contain all the @keywords if there are more than one" do
      @task = Pajamas::Task.new "@behaviour @other_behaviour Some Task "
      @task.behaviour_names.should == ['behaviour', 'other_behaviour']
    end

  end
  
  describe "behaviours" do
    it "should attempt to instantiate behaviours" do
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour"])
      @task.behaviours.length.should == 1
      @task.behaviours[0].should be_kind_of(Pajamas::Behaviours::BehaviourBehaviour)
    end
    
    it "should attempt to instantiate all behaviours" do
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour", "other_behaviour"])
      @task.behaviours.length.should == 2
      @task.behaviours[0].should be_kind_of(Pajamas::Behaviours::BehaviourBehaviour)
      @task.behaviours[1].should be_kind_of(Pajamas::Behaviours::OtherBehaviourBehaviour)
    end
    
    it "should ignore missing behaviours" do
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour", "missing_behaviour"])
      @task.behaviours.length.should == 1
      @task.behaviours[0].should be_kind_of(Pajamas::Behaviours::BehaviourBehaviour)
    end
  end
  
  describe "children" do
    
    it "should include generated_children if children is empty" do
      @task = Pajamas::Task.new ""
      behaviour = mock("Behaviour")
      @task.should_receive(:behaviours).and_return([behaviour])
      
      behaviour.should_receive(:generated_substeps).and_return([:substeps])
      @task.children.should == [:substeps]
    end
    
  end
  

end
