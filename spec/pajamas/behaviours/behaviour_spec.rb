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


  it "should have name method" do
    class NamedBehaviour < Pajamas::Behaviours::Behaviour; end;
    @behave = NamedBehaviour.new :task
    @behave.name.should == "named"  
  end
end
