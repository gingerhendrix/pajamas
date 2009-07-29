Feature: Task Done
  In order to progress with what I am doing and keep in the Flow
  I want to be mark my current task done
  
  Scenario: Task done
    Given a todo list with some done items
    When I execute "pj-tasks-done"
    Then the current task should be marked done
    And I should see the task marked done
    
  Scenario: Task done
    Given a todo list with a task with a generated substep
    When I execute "pj-tasks-done"
    Then the generated task should be marked done
    And I should see the generated task marked done    
