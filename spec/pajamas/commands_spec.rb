require File.dirname(__FILE__) + '/../spec_helper'


describe "Tasks Command", :shared => true do

    before(:each) do
      @todoFile = mock("Todo File")
      Pajamas::TodoFile.stub!(:read_file).and_return(@todoFile)
    end


  it "should create new todo file from ./TODO if no args are supplied" do
    Pajamas::TodoFile.should_receive(:read_file).with("TODO").and_return(@todoFile)
    command = new_command []
    command.stub!(:puts)
    command.run
  end

  it "should create new todo file from filename if args are supplied" do
      Pajamas::TodoFile.should_receive(:read_file).with("FILENAME").and_return(@todoFile)

      command = new_command ['FILENAME']
      command.stub!(:puts)
      command.run
  end


end

describe "Commands::Tasks::List" do

  describe "run" do
    it_should_behave_like "Tasks Command"

    before(:each) do
      @todoFile.stub!(:to_console)
    end 
  
    def new_command(args)
      command = Pajamas::Commands::Tasks::List.new args
      command.stub!(:puts)
      command
    end
    
    it "should output the files to_console" do
      @todoFile.should_receive(:to_console).and_return("OUTPUT")
      command = new_command ['FILENAME']
      command.should_receive(:puts).with("OUTPUT")
      
      command.run
    end
    
  end
end

describe "Commands::Tasks::Next" do

  describe "run" do
    it_should_behave_like "Tasks Command"
    
    before(:each) do
      @todoFile.stub!(:current_to_console)
    end 
  
    def new_command(args)
      command = Pajamas::Commands::Tasks::Next.new args
      command.stub!(:puts)
      command
    end
    
    it "should output the current context to console" do
      @todoFile.should_receive(:current_to_console).and_return("OUTPUT")
      command = Pajamas::Commands::Tasks::Next.new ['FILENAME']
      command.should_receive(:puts).with("OUTPUT")
      
      command.run
    end
    
  end
end

describe "Commands::Tasks::Done" do
  describe "run" do
    it_should_behave_like "Tasks Command"     

    def new_command(args)
      command = Pajamas::Commands::Tasks::Done.new args
      command.stub!(:puts)
      command
    end
    
    before(:each) do
      @current = mock("Current Task")
      @current.stub!(:done!)
      @current.stub!(:to_string)
      @todoFile.stub!(:current).and_return(@current)
      @todoFile.stub!(:save).and_return(@current)
    end
    
    it "should mark the current task done" do
      @todoFile.should_receive(:current).and_return(@current)
      @current.should_receive(:done!)
      command = new_command ['FILENAME']
      command.run
    end
   
    it "should write the todo file" do
      @todoFile.should_receive(:save)
      command = new_command ['FILENAME']
      command.run
    end
    
    it "should output the current task to console" do
      @todoFile.should_receive(:current).and_return(@current)
      @current.should_receive(:to_string).and_return("OUTPUT")

      command = new_command ['FILENAME']
      
      command.should_receive(:puts).with("OUTPUT")
      command.run          
    end
    
  end
end
