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

end
