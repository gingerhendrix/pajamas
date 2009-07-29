$: << File.dirname(__FILE__) + "/../../lib"
require 'spec'
require 'pajamas'

FIXTURES_DIR = File.dirname(__FILE__) + "/../fixtures"
LIVE_DIR = File.dirname(__FILE__) + "/../fixtures/live"

Given /^a todo list$/ do
  FileUtils.copy FIXTURES_DIR + "/TODO", LIVE_DIR + "/TODO"
  @todoFile = LIVE_DIR + "/TODO";
end

Given /^a todo list with some done items$/ do
  FileUtils.copy FIXTURES_DIR + "/TODO_WITH_DONE", LIVE_DIR + "/TODO_WITH_DONE"
  @todoFile = LIVE_DIR + "/TODO_WITH_DONE";
end

Given /^a todo list with a task with a generated substep$/ do
  FileUtils.copy FIXTURES_DIR + "/TODO_WITH_GENERATED_SUBSTEP", LIVE_DIR + "/TODO_WITH_GENERATED_SUBSTEP"
  @todoFile = LIVE_DIR + "/TODO_WITH_GENERATED_SUBSTEP";
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

