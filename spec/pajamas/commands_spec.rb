require File.dirname(__FILE__) + '/../spec_helper'

describe "Commands::Tasks::List" do

  describe "run" do
  
    it "should create new todo file from ./TODO if no args are supplied" do
      Pajamas::TodoFile.should_receive(:read_file).with("TODO").and_return(Pajamas::TodoFile.new)

      task = Pajamas::Commands::Tasks::List.new []
      task.run
    end
    
    it "should create new todo file from filename if args are supplied" do
      Pajamas::TodoFile.should_receive(:read_file).with("FILENAME").and_return(Pajamas::TodoFile.new)

      task = Pajamas::Commands::Tasks::List.new ['FILENAME']
      task.run
    end

    
    it "should output the files to_console" do
      todoFile = mock("Todo File")
      Pajamas::TodoFile.stub!(:read_file).and_return(todoFile)
      todoFile.should_receive(:to_console).and_return("OUTPUT")
      task = Pajamas::Commands::Tasks::List.new ['FILENAME']
      task.should_receive(:puts).with("OUTPUT")
      
      task.run
    end
    
  end
end
