$: << File.dirname(__FILE__) + "/../../lib"
require 'spec'
require 'pajamas'

FIXTURES_DIR = File.dirname(__FILE__) + "/../fixtures"
LIVE_DIR = File.dirname(__FILE__) + "/../fixtures/live"

class TodoWorld
  def fixture(name)
    @fixtureFile = FIXTURES_DIR + "/" + name 
    @todoFile = LIVE_DIR + "/" + name;
    FileUtils.copy @fixtureFile, @todoFile
  end
end
World do
  TodoWorld.new
end

Given /^a todo list$/ do
  fixture('TODO')
end

Given /^a todo list with some done items$/ do
  fixture('TODO_WITH_DONE')
end

Given /^a todo list with a task with a generated substep$/ do
  fixture('TODO_WITH_GENERATED_SUBSTEP')
end

When /^I execute "([^\"]*)"$/ do |command|
  @output = `./bin/#{command} #{@todoFile}`
end

Then /^I should see all the tasks$/ do
  @output.should == File.read(@todoFile)
end

Then /^I want to see the current task and its parents$/ do
  @output.should == "Context 1\n  Context 2\n    Task\n"
end

Then /^the current task should be marked done$/ do
  todo = Pajamas::TodoFile.read_file @todoFile
  puts todo.to_console
  todo.items[5].should be_done
end

Then /^I should see the task marked done$/ do
  @output.should == "Task +done\n"
end

Then /^I want to see the substep$/ do
  @output.should == "@tdd Some Task\n  Write failing test\n"
end

Then /^the generated task should be marked done$/ do
  todo = Pajamas::TodoFile.read_file @todoFile
  puts todo.to_console
  todo.items[1].should be_done
end

Then /^I should see the generated task marked done$/ do
  @output.should == "Write failing test +done\n"
end

Then /^the file should not be changed$/ do
  File.read(@todoFile).should == File.read(@fixtureFile)
end

Then /^the file should include the substeps$/ do
  lines = File.read(@todoFile).split("\n")
  lines.length.should == 4
  lines[1].should == "  Write failing test"
  lines[2].should == "  Write code to make test pass"
end

Then /^the substep should be marked generated \- '!'$/ do
  lines = File.read(@todoFile).split("\n")
  lines[0].should == "@tdd! Some Task"
end


