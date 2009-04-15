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

end
