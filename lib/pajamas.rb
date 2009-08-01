
require 'rubygems'
require 'activesupport'

$: << File.dirname(__FILE__)

require 'pajamas/todo_file'
require 'pajamas/task'
require 'pajamas/commands'

require 'pajamas/behaviours/behaviour'
require 'pajamas/behaviours/tdd_behaviour'
require 'pajamas/behaviours/spec_behaviour'
