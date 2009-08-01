require File.dirname(__FILE__) + '/../../spec_helper'


describe "Behaviour" do

  it "should have done? method" do
    @behave = Pajamas::Behaviours::Behaviour.new :task
    @behave.done?.should === false
    @behave.done = true
    @behave.done?.should === true
  end
  
  it "should have name method" do
    @behave = Pajamas::Behaviours::Behaviour.new :task
    @behave.name.should == "behaviour"  
  end


  it "name method should be derieved from class name" do
    class NamedBehaviour < Pajamas::Behaviours::Behaviour; end;
    @behave = NamedBehaviour.new :task
    @behave.name.should == "named"  
  end
  
  it "should have message" do
    @behave = Pajamas::Behaviours::Behaviour.new :task
    @behave.message.should be_nil
  end
end
