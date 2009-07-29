require File.dirname(__FILE__) + '/../spec_helper'

describe "Task" do
  
  describe "initialize" do
    it "should have default state" do 
      @task = Pajamas::Task.new "Some Task"
      @task.parent.should == nil
      @task.children.should == []
      @task.to_string.should == "Some Task"
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
      class BehaviourBehaviour; def initialize(t); end; end;
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour"])
      @task.behaviours.length.should == 1
      @task.behaviours[0].should be_kind_of(BehaviourBehaviour)
    end
    
    it "should attempt to instantiate all behaviours" do
      class BehaviourBehaviour; def initialize(t); end; end;
      class OtherBehaviourBehaviour; def initialize(t); end; end;
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour", "other_behaviour"])
      @task.behaviours.length.should == 2
      @task.behaviours[0].should be_kind_of(BehaviourBehaviour)
      @task.behaviours[1].should be_kind_of(OtherBehaviourBehaviour)
    end
    
    it "should ignore missing behaviours" do
      class BehaviourBehaviour; def initialize(t); end; end;
      @task = Pajamas::Task.new ""
      @task.stub!(:behaviour_names).and_return(["behaviour", "missing_behaviour"])
      @task.behaviours.length.should == 1
      @task.behaviours[0].should be_kind_of(BehaviourBehaviour)
    end


  end

end
