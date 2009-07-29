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
        Pajamas::Task.should_receive(:new).with(line.strip).and_return(mock)
      end
      @todo = Pajamas::TodoFile.read_string(@todoTxt)
    end
    
    it "should have a list of items" do
      @todo = Pajamas::TodoFile.read_string(@todoTxt)

      @todo.items.should be_kind_of(Array)
      @todo.items.length.should == 8
      @todo.items[1].to_string.should == @line2.strip
    end
    
    it "should have a list of root items" do
      @todo = Pajamas::TodoFile.read_string(@todoTxt)

      @todo.roots.should be_kind_of(Array)
      @todo.roots.length.should == 2
      @todo.roots[1].to_string.should == @line8.strip
    end
    
    it "should set parent and children of items" do
      @todo = Pajamas::TodoFile.read_string(@todoTxt)
      @todo.roots[0].parent.should == nil
 
      @todo.roots[0].children.should be_kind_of(Array)
      @todo.roots[0].children.length.should == 2
 
      @todo.roots[0].children[0].parent.should === @todo.roots[0]
       @todo.roots[0].children[0].to_string.should == @line2.strip
      
      @todo.roots[0].children[1].children.length.should == 3
      @todo.roots[0].children[1].children[1].parent.should ===  @todo.roots[0].children[1] 
      @todo.roots[0].children[1].children[1].children.should == []
      @todo.roots[0].children[1].children[1].to_string.should == @line6.strip
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
  
  describe "current" do

    before do
      @todo = Pajamas::TodoFile.new
      @root = mock("ROOT", {:children => [], :done? => false})
      @todo.stub!(:roots).and_return([@root])    
    end

    it "should start at the root" do
      @todo.should_receive(:roots).and_return([@root])
      @todo.current.should == @root
    end
    
    it "should continue to the next item if done" do
      @root2 = mock("ROOT2", {:children => [], :done? => false})

      @root.should_receive(:done?).and_return(true)
      @todo.stub!(:roots).and_return([@root, @root2])
      @todo.current.should == @root2
    end
    
    it "should continue to the children if exist" do
      @child = mock("child", {:children => [], :done? => false})
     
      @root.should_receive(:children).and_return([@child])
      @todo.current.should == @child
    end

  
  end

  
  describe "to_console" do 
  
    it "should return each of the items separated by newlines" do
      @todo = Pajamas::TodoFile.read_string "Line1\nLine2\nLine3"
      @todo.to_console.should == "Line1\nLine2\nLine3"
    end
  
  end
   
  describe "current_to_console" do
    before do
      @todo = Pajamas::TodoFile.new
      @current = mock("Current")
      @current.stub!(:parent)
      @todo.stub!(:current).and_return(@current)
      @current.stub!(:to_string)
    end
    
    it "should print the current task" do
      @current.should_receive(:to_string)
      @todo.current_to_console
    end
    
    it "should print the tasks parent" do
      parent = mock("Parent", :parent => nil)
      @current.stub!(:parent).and_return(parent)

      parent.should_receive(:to_string)
      @todo.current_to_console
    end
    
    it "should print the tasks parent's parent" do
      grandparent = mock("GrandParent", :parent => nil)
      parent = mock("Parent", :parent => grandparent, :to_string => "")
      @current.stub!(:parent).and_return(parent)

      grandparent.should_receive(:to_string)
      @todo.current_to_console
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
