require File.dirname(__FILE__) + '/../spec_helper'

describe "Commands::Tasks::List" do

  describe "run" do
  
    it "should create new todo file from ./TODO if no args are supplied" do
      Pajamas::TodoFile.should_receive(:read_file).with("TODO").and_return(Pajamas::TodoFile.new)

      command = Pajamas::Commands::Tasks::List.new []
      command.stub!(:puts)
      command.run
    end
    
    it "should create new todo file from filename if args are supplied" do
      Pajamas::TodoFile.should_receive(:read_file).with("FILENAME").and_return(Pajamas::TodoFile.new)

      command = Pajamas::Commands::Tasks::List.new ['FILENAME']
      command.stub!(:puts)
      command.run
    end

    
    it "should output the files to_console" do
      todoFile = mock("Todo File")
      Pajamas::TodoFile.stub!(:read_file).and_return(todoFile)
      todoFile.should_receive(:to_console).and_return("OUTPUT")
      command = Pajamas::Commands::Tasks::List.new ['FILENAME']
      command.should_receive(:puts).with("OUTPUT")
      
      command.run
    end
    
  end
end

describe "Commands::Tasks::Next" do

  describe "run" do
    
    before(:each) do
      @todoFile = mock("Todo File")
      @todoFile.stub!(:current_to_console)
    end
  
    it "should create new todo file from ./TODO if no args are supplied" do
      Pajamas::TodoFile.should_receive(:read_file).with("TODO").and_return(@todoFile)

      command = Pajamas::Commands::Tasks::Next.new []
      command.stub!(:puts)
      command.run
    end
    
    it "should create new todo file from filename if args are supplied" do
      Pajamas::TodoFile.should_receive(:read_file).with("FILENAME").and_return(@todoFile)

      command = Pajamas::Commands::Tasks::Next.new ['FILENAME']
      command.stub!(:puts)
      command.run
    end

    
    it "should output the current context to console" do

      Pajamas::TodoFile.stub!(:read_file).and_return(@todoFile)
      @todoFile.should_receive(:current_to_console).and_return("OUTPUT")
      command = Pajamas::Commands::Tasks::Next.new ['FILENAME']
      command.should_receive(:puts).with("OUTPUT")
      
      command.run
    end
    
  end
end
