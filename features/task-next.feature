Feature: Next Task
  In order to remember what I am doing and keep in the Flow
  I want to be able to see my current (next) task with context
  
  Scenario: Next Task
    Given an empty todo list 
    Given the todo list has item "Grandparent"
    Given the todo list has item "  Parent"
    Given the todo list has item "    Current"
    When I execute "pj-tasks-next"
    Then I want to see "Grandparent" on line 0
    Then I want to see "  Parent" on line 1
    Then I want to see "    Current" on line 2
    And the file should not be changed
    
  Scenario: Next Task with done items
    Given an empty todo list 
    Given the todo list has item "Grandparent"
    Given the todo list has item "  Parent"
    Given the todo list has item "    Ignore +done"
    Given the todo list has item "    Current"
    When I execute "pj-tasks-next"
    Then I want to see "Grandparent" on line 0
    Then I want to see "  Parent" on line 1
    Then I want to see "    Current" on line 2
    And the file should not be changed

    
  Scenario: Task with generated substeps
    Given an empty todo list 
    Given the todo list has item "@tdd Task"
    When I execute "pj-tasks-next"
    Then I want to see "@tdd! Task" on line 0
    Then I want to see "  Write failing test" on line 1
    And the file should include "@tdd! Task" on line 0
    And the file should include "  Write failing test" on line 1
    And the file should include "  Write code to make test pass" on line 2
    
  Scenario: Task with generated message
    Given an empty todo list 
    Given the todo list has item "@spec Task"
    When I execute "pj-tasks-next"
    Then I want to see "@spec Task" on line 0
    And I want to see "Message: Write a failing spec - run 'rake spec'" on line 2
    And the file should not be changed
