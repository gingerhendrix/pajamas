require 'spec'

Given /^a todo list$/ do
  @todoFile = File.dirname(__FILE__) + "/../fixtures/TODO";
end

Given /^a todo list with some done items$/ do
  @todoFile = File.dirname(__FILE__) + "/../fixtures/TODO_WITH_DONE";
end

When /^I execute "([^\"]*)"$/ do |command|
  @output = `./script/#{command} #{@todoFile}`
end

Then /^I should see all the tasks$/ do
  @output.should == File.read(@todoFile)
end

Then /^I want to see the current task and its parents$/ do
  @output.should == "Context 1\n  Context 2\n    Task\n"
end

