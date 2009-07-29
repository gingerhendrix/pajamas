Feature: Next Task
  In order to remember what I am doing and keep in the Flow
  I want to be able to see my current (next) task with context
  
  Scenario: Next Task
    Given a todo list with some done items
    When I execute "pj-tasks-next"
    Then I want to see the current task and its parents
    
  Scenario: Task with generated substeps
    Given a todo list with a task with a generated substep
    When I execute "pj-tasks-next"
    Then I want to see the substep
