Feature: List tasks
  In order to examine where I am and what my plans are for a project
  I should be able to list all the tasks
  
  Scenario: List all tasks
    Given a todo list
    When I execute "pj-tasks-list"
    Then I should see all the tasks
