# frozen_string_literal: false

require_relative "modular_state_machine/version"
require "active_support/concern"

module ModularStateMachine
  extend ActiveSupport::Concern

  included do
  end

  class Error < StandardError; end

  module ClassMethods
    #
    # Builds a module with constants assigned to the index passed in the `options` array. Be sure
    # to pass all arguments as you would write them manually. In other words `attribute` and any
    # constants passed in `options` should be classified case (e.g. ThisModule).
    #
    # `attribute` = Name of the class attribute that should be the module"s name. MUST be a attribute
    #               of the class.
    # `options`   = Array of constants identified with `attribute`
    #
    # example
    #     state_machine_for("Category", ["PeerReviewed", "NonPeerReviewed", "CaseStudy"])
    #
    def state_machine_for(attribute, options = [])
      constants = ""
      options.each_with_index do |constant, index|
        constants << "#{constant} = #{index}; "
      end
      mod = %(module #{attribute}; #{constants} def self.names; #{options.map(&:to_sym)}; end; end)
      module_eval(mod)
      build_boolean_instance_methods(attribute, options)
      build_mutable_instance_methods(attribute, options)
    end

    #
    # Builds out the boolean methods for constants defined in `mod_machine_for`.
    # Arguments must follow the same format as the aforementioned method.
    #
    def build_boolean_instance_methods(attribute, options = [])
      options.each do |const|
        puts const.class

        class_eval <<-RUBY
          def #{const.to_s.split("::").last.tableize.singularize}?
            self.#{attribute.downcase} == #{attribute}::#{const.to_s.demodulize}
          end
        RUBY
      end
    end

    #
    # Builds out mutable update methods for constants defined in `state_machine_for`.
    # Arguments must follow the same format as the aforementioned method.
    #
    # example
    #   object.case_study!
    #     #=> UPDATE "objects" SET "category" = 2 WHERE "objects"."id" = 1;
    #   object.case_study?
    #     #=> true
    #
    def build_mutable_instance_methods(attribute, options = [])
      column = ":" + attribute.to_s.downcase
      options.each do |const|
        class_eval <<-RUBY
          def #{const.to_s.demodulize.tableize.singularize}!
            update_attribute #{column}, #{attribute}::#{const.to_s.demodulize}
          end
        RUBY
      end
    end
  end # End ClassMethods
end # End ModularStateMachine

class String
  def demodulize
    self.split('::').last
  end

  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr("-", "_")
      .downcase
  end

  def pluralize
    self + 's'
  end

  def tableize
    underscore.pluralize
  end

  def singularize
    self.end_with?('s') ? self[0...-1] : self
  end
end
