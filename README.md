
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

1. **Integer Fields for States:**

   To use integer fields for states, add an integer column to your model and map states to integers.

   ```ruby
   add_column :applicants, :status, :integer, default: 0
   ```

2. **Including the Module:**

   Include `ModularStateMachine` in your ActiveRecord model.

   ```ruby
   class Applicant < ApplicationRecord
     include ModularStateMachine
   end
   ```

3. **Defining a State Machine:**

   Use `mod_machine_for` to define a state machine for a specific field.

   ```ruby
   mod_machine_for('Status', %w[Pending Active Approved Denied Archived])
   ```

4. **Defining Scopes:**

   Define scopes for each state for easy querying.

   ```ruby
   scope :pending, -> { where(status: Status::Pending) }
   ```

### Checking States

To check the state of an object, use the generated query methods.

```ruby
applicant = Applicant.create(status: Status::Active)
applicant.active? # => true
```   

### Advanced Usage

1. **Multiple State Machines:**

   You can define multiple state machines for different fields in the same model.

   ```ruby
   class User < ApplicationRecord
     include ModularStateMachine

     state_machine_for('Status', %w[Pending Active Approved Denied Archived])
     state_machine_for('Role', %w[Admin Buyer Seller])
   
     scope :pending, -> { where(status: Status::Pending) }    
     # ... other scopes
   end
   ```

   Usage:

   ```ruby
   applicant = Applicant.last
   applicant.pending? # => true
   applicant.admin? # => true
   applicant.buyer? #=> false
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
   applicant = Applicant.new(status: Status::Pending)
   applicant.pending? # => true
   applicant.status = Status::Denied
   applicant.pending? # => false
   applicant.denied? #=> true
   ```

2. **Exam Ruby Class with a State Machines:**

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
