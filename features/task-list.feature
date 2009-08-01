Feature: List tasks
  In order to examine where I am and what my plans are for a project
  I should be able to list all the tasks
  
  Scenario: List all tasks
    Given a todo list
    When I execute "pj-tasks-list"
    Then I should see all the tasks
    
  Scenario: List all tasks with generated substeps
    Given a todo list with a task with a generated substep
    When I execute "pj-tasks-list"
    Then I should see all the tasks with the generated substeps
    And the file should include the substeps
    And the substep should be marked generated - '!'
  
