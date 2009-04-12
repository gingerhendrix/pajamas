require 'spec'

Given /^a todo list$/ do
  @todoFile = File.dirname(__FILE__) + "/../fixtures/TODO";
end

When /^I execute "([^\"]*)"$/ do |command|
  @output = `./script/#{command} #{@todoFile}`
end

Then /^I should see all the tasks$/ do
  @output.should == File.read(@todoFile)
end

