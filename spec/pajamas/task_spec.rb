require File.dirname(__FILE__) + '/../spec_helper'

module Pajamas  
  module Behaviours
    class BehaviourBehaviour < Behaviour; def initialize(t); end; end;
    class OtherBehaviourBehaviour  < Behaviour; def initialize(t); end; end;
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
    
    it "should have done behaviours marked done" do
      @task = Pajamas::Task.new "@behaviour"
      @task.behaviours[0].done = true
      @task.to_string.should == "@behaviour!"
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

    it "should contain the ! if the @keyword is marked done" do
      @task = Pajamas::Task.new "@behaviour @other_behaviour! Some Task! "
      @task.behaviour_names.should == ['behaviour', 'other_behaviour!']
    end

  end
  
  describe "behaviours" do
    it "should attempt to instantiate behaviours" do
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour"])

      behave = @task.generate_behaviours
      behave.length.should == 1
      behave[0].should be_kind_of(Pajamas::Behaviours::BehaviourBehaviour)
    end
    
    it "should attempt to instantiate all behaviours" do
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour", "other_behaviour"])

      behave = @task.generate_behaviours
      behave.length.should == 2
      behave[0].should be_kind_of(Pajamas::Behaviours::BehaviourBehaviour)
      behave[0].should_not be_done
      behave[1].should be_kind_of(Pajamas::Behaviours::OtherBehaviourBehaviour)
      behave[1].should_not be_done
    end
    
    it "should ignore missing behaviours" do
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour", "missing_behaviour"])

      behave = @task.generate_behaviours
      behave.length.should == 1
      behave[0].should be_kind_of(Pajamas::Behaviours::BehaviourBehaviour)
    end
    
    it "should mark done behavours done" do
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour!"])

      behave = @task.generate_behaviours
      behave.length.should == 1
      behave[0].should be_kind_of(Pajamas::Behaviours::BehaviourBehaviour)
      behave[0].should be_done
    end
    
    
  end
  
  describe "generate_children" do
    
    before do
      @task = Pajamas::Task.new ""
      @behaviour = mock("Behaviour")
      @behaviour.stub!(:done?).and_return(false)
      @behaviour.stub!(:done=)
     @behaviour.stub!(:generated_substeps).and_return([:substeps])
      @task.stub!(:behaviours).and_return([@behaviour])
      
    end
    
    it "should include generated_children" do
      @behaviour.should_receive(:generated_substeps).and_return([:substeps])
      @task.generate_children
      @task.children.should == [:substeps]
    end
    
    it "should not include generated_childen of behaviours marked done" do
      @behaviour.should_receive(:done?).and_return(true) 
      @behaviour.should_not_receive(:generated_substeps)
      @task.generate_children
      @task.children.should == []
    end
    
    it "should mark behaviour done" do
      @behaviour.should_receive(:done=).with(true)
      @task.generate_children
    end
  end
  

end
