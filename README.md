
# ModularStateMachine

The `ModularStateMachine` is a Ruby module designed to integrate state machine behavior into ActiveRecord models. It's highly flexible and can be used to manage various states within your Rails application.

## Installation

Include the `ModularStateMachine` module in your Gemfile:

```ruby
gem 'modular_state_machine'
```

Run the bundle command to install it:

```bash
bundle install
```

## Usage

### Basic Usage

1. **Including the Module:**

   Include `ModularStateMachine` in your ActiveRecord model.

   ```ruby
   class Applicant < ApplicationRecord
     include ModularStateMachine
   end
   ```

2. **Defining a State Machine:**

   Use `mod_machine_for` to define a state machine for a specific field.

   ```ruby
   mod_machine_for('Status', %w[Pending Active Approved Denied Archived])
   ```

3. **Defining Scopes:**

   Define scopes for each state for easy querying.

   ```ruby
   scope :pending, -> { where(status: Status::Pending) }
   ```

### Advanced Usage

1. **Multiple State Machines:**

   You can define multiple state machines for different fields in the same model.

   ```ruby
   class ExamClass
     include ModularStateMachine
     attr_accessor :category
     state_machine_for('Category', ['PeerReviewed', 'NonPeerReviewed', 'CaseStudy', 'Flyies'])
   end
   ```

2. **Integer Fields for States:**

   To use integer fields for states, add an integer column to your model and map states to integers.

   ```ruby
   add_column :applicants, :status, :integer, default: 0
   ```

   Then, use a hash to define the mapping in `mod_machine_for`.

   ```ruby
   mod_machine_for('Status', { pending: 0, active: 1, approved: 2, denied: 3, archived: 4 })
   ```

### Checking States

To check the state of an object, use the generated query methods.

```ruby
a = Applicant.create(status: Status::Pending)
a.pending? # => true
```

## Examples

1. **Applicant Model with State Machine:**

   ```ruby
   class Applicant < ApplicationRecord
     include ModularStateMachine

     mod_machine_for('Status', %w[Pending Active Approved Denied Archived])
     scope :pending, -> { where(status: Status::Pending) }
     # ... other scopes
   end
   ```

   Usage:

   ```ruby
   applicant = Applicant.new
   applicant.status = Status::Pending
   applicant.pending? # => true
   ```

2. **Exam Class with Multiple State Machines:**

   ```ruby
   class ExamClass
     include ModularStateMachine
     attr_accessor :category

     state_machine_for('Category', ['PeerReviewed', 'NonPeerReviewed', 'CaseStudy', 'Flyies'])
     # ... additional configurations
   end
   ```

   Usage:

   ```ruby
   exam = ExamClass.new
   exam.category = 'PeerReviewed'
   exam.category_peer_reviewed? # => true
   ```
