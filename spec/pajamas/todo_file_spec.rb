require File.dirname(__FILE__) + '/../spec_helper'

describe "TodoFile" do

  describe "#read_string" do

    it "should create a new Task for each line in the string" do
      @line1 = "A todo task"
      @line2 = "  A sub task"
      @line3 = "Another task"
      @todoTxt = @line1 + "\n" + @line2 + "\n" + @line3

      @todo = Pajamas::TodoFile.read_string(@todoTxt)

      @todo.items.should be_kind_of(Array)
      @todo.items.length.should == 3
      @todo.items[1].should == @line2
    end
    
    
  end
  
  describe "#read_file" do
    it "should read the file specified and call #read_string" do
      File.should_receive(:read).with("FILENAME").and_return("OUT")
      Pajamas::TodoFile.should_receive(:read_string).with("OUT")
      @todo = Pajamas::TodoFile.read_file("FILENAME")
    end
  end
  
  describe "to_console" do 
  
    it "should return each of the items separated by newlines" do
      @todo = Pajamas::TodoFile.new 
      @todo.items = ["Line1", "Line2", "Line3"]
      @todo.to_console.should == "Line1\nLine2\nLine3"
    end
  
  end

end
