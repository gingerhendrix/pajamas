require File.dirname(__FILE__) + '/../spec_helper'

describe "TodoFile" do
    before(:each) do
     @line1 = "Context 1"
     @line2 = "  A Completed Task +done"
     @line3 = "    A completed subtask +done"
     @line4 = "  Context 2"
     @line5 = "    Another completed subtask +done"
     @line6 = "    Task"
     @line7 = "    Another Task"
     @line8 = "Another Root Task"
     @todoTxt = @line1 + "\n" + @line2 + "\n" + @line3 + "\n" + @line4  + "\n" + @line5   + "\n" + @line6   + "\n" + @line7 + "\n" + @line8       
    end


  describe "#read_string" do

    it "should create a new Task for each line in the string" do
      mock = mock('task', :null_object => true)
      [@line1, @line2, @line3, @line4, @line5, @line6, @line7, @line8].each do |line|
        Pajamas::Task.should_receive(:new).with(line).and_return(mock)
      end
      @todo = Pajamas::TodoFile.read_string(@todoTxt)
    end
    
    it "should have a list of items" do
      @todo = Pajamas::TodoFile.read_string(@todoTxt)

      @todo.items.should be_kind_of(Array)
      @todo.items.length.should == 8
      @todo.items[1].to_string.should == @line2
    end
    
    it "should have a list of root items" do
      @todo = Pajamas::TodoFile.read_string(@todoTxt)

      @todo.roots.should be_kind_of(Array)
      @todo.roots.length.should == 2
      @todo.roots[1].to_string.should == @line8
    end
    
    it "should set parent and children of items" do
      @todo = Pajamas::TodoFile.read_string(@todoTxt)
      @todo.roots[0].parent.should == nil
 
      @todo.roots[0].children.should be_kind_of(Array)
      @todo.roots[0].children.length.should == 2
 
      @todo.roots[0].children[0].parent.should === @todo.roots[0]
       @todo.roots[0].children[0].to_string.should == @line2
      
      @todo.roots[0].children[1].children.length.should == 3
      @todo.roots[0].children[1].children[1].parent.should ===  @todo.roots[0].children[1] 
      @todo.roots[0].children[1].children[1].children.should == []
      @todo.roots[0].children[1].children[1].to_string.should == @line6
    end
    
    it "should have a current task" do
      @todo = Pajamas::TodoFile.read_string(@todoTxt)
      @todo.current.to_string.should === @todo.items[5].to_string
    end
    
  end
  
  describe "#read_file" do
    it "should read the file specified and call #read_string" do
      File.should_receive(:read).with("FILENAME").and_return("Task1\nTask2")
      Pajamas::TodoFile.should_receive(:read_string).with("Task1\nTask2").and_return(Pajamas::TodoFile.new)
      @todo = Pajamas::TodoFile.read_file("FILENAME")
    end
    
    it "should set the filename property" do
      File.stub!(:read).with("FILENAME").and_return("Task1\nTask2")
      Pajamas::TodoFile.stub!(:read_string).with("Task1\nTask2").and_return(Pajamas::TodoFile.new)
      @todo = Pajamas::TodoFile.read_file("FILENAME")
      @todo.filename.should == "FILENAME"
    end
  end
  
  describe "to_console" do 
  
    it "should return each of the items separated by newlines" do
      @todo = Pajamas::TodoFile.read_string "Line1\nLine2\nLine3"
      @todo.to_console.should == "Line1\nLine2\nLine3"
    end
  
  end
  
  describe "current" do
    it "should have the correct current task" do
      @todo = Pajamas::TodoFile.read_string @todoTxt
      @todo.current.to_string.should == "    Task"
      
    end
  end
  
  describe "current_to_console" do
    it "should return the current task and its context" do
      @todo = Pajamas::TodoFile.read_string @todoTxt
      @todo.current_to_console.should == "Context 1\n  Context 2\n    Task"
    end
  end
  
  describe "to_file" do
    it "should return each of the items separated by newlines" do
      @todo = Pajamas::TodoFile.read_string "Line1\nLine2\nLine3"
      @todo.to_file.should == "Line1\nLine2\nLine3"
    end
  end
  
  describe "save" do
    before(:each) do
      @file = mock("File");
      @file.stub!(:write)
      File.stub!(:new).and_return(@file)
    end
    
    it "should save to filename if supplied" do
      File.should_receive(:new).with("FILENAME", "w")
      @todo = Pajamas::TodoFile.read_string "Line1\nLine2\nLine3"
      @todo.save "FILENAME"
    end
    
    it "should save to todo.filename of set " do
      File.should_receive(:new).with("FILENAME", "w").and_return(@file)
      @todo = Pajamas::TodoFile.read_string "Line1\nLine2\nLine3"
      @todo.filename = "FILENAME"
      @todo.save
    end
    
    it "should write the contents of to_file to the file" do
      @todo = Pajamas::TodoFile.read_string "Line1\nLine2\nLine3"
      @todo.should_receive(:to_file).and_return("CONTENTS");
      @file.should_receive(:write).with("CONTENTS")
      @todo.save "FILENAME"      
    end
    
    it "should raise a StandardError if the filename is not specified" do
      @todo = Pajamas::TodoFile.read_string "Line1\nLine2\nLine3"
      lambda { @todo.save }.should raise_error(StandardError)
    end
    
  end

end
