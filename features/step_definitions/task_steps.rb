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
    @originalItems = File.read(@todoFile).split("\n")
  end
end
World do
  TodoWorld.new
end

Given /^a todo list$/ do
  fixture('TODO')
end

Given /^an empty todo list$/ do
  fixture('EMPTY_TODO')
end

Given /^the todo list has item "([^\"]*)"$/ do |item|
  @originalItems << item
  File.open(@todoFile, "w") { |f| f.write(@originalItems.join("\n").strip) };
end


Given /^a todo list with some done items$/ do
  fixture('TODO_WITH_DONE')
end

Given /^a todo list with a task with a generated substep$/ do
  fixture('TODO_WITH_GENERATED_SUBSTEP')
end

When /^I execute "([^\"]*)"$/ do |command|
  @output = `./bin/#{command} #{@todoFile}`
  @output_lines = @output.split("\n")
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
  @output.should == "@tdd! Some Task\n  Write failing test\n"
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
  File.read(@todoFile).split("\n").should == @originalItems
end

Then /^the file should include the substeps$/ do
  lines = File.read(@todoFile).split("\n")
  lines.length.should == 4
  lines[1].should be_include "Write failing test"
  lines[2].should be_include "Write code to make test pass"
end

Then /^the substep should be marked generated \- '!'$/ do
  lines = File.read(@todoFile).split("\n")
  lines[0].should == "@tdd! Some Task"
end

Then /^the file should have the task marked done$/ do
  lines = File.read(@todoFile).split("\n")
  lines[5].should == "    Task +done"
end

Then /^the file should have the generated task marked done$/ do
  lines = File.read(@todoFile).split("\n")
  lines[1].should be_include "+done"

end

Then /^I should see all the tasks with the generated substeps$/ do
  lines = @output.split("\n")
  lines[1].should be_include "Write failing test"
  lines[2].should be_include "Write code to make test pass"
end

Then /^I want to see "([^\"]*)" on line ([0-9]+)$/ do |out, line|
  @output_lines[line.to_i].should be_include(out)
end

Then /^the file should include "([^\"]*)" on line ([0-9]+)$/ do |out, line|
  File.read(@todoFile).split("\n")[line.to_i].should be_include(out)
end



