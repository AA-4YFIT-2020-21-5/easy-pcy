# frozen_string_literal: true

module CourseData
  class Quiz
    def initialize(prompt:, type: :generic, solution: nil, options: nil)
      @prompt = prompt
      @type = type.to_s.underscore.to_sym
      @solution = solution
      @options = options || []

      if @type == :true_false
        @solution = ActiveModel::Type::Boolean.new.cast(@solution)
      end
    end

    attr_reader :prompt, :type, :options, :solution

    alias_method :answer, :solution

    def s_solution
      case type
      when :true_false then TF_STRING[solution] || solution
      else solution
      end
    end

    def to_json
      json = { type: type.to_s.camelize, prompt: prompt, answer: answer }
      json[:options] = options if type == :multiple_choice
      json[:answer] = answer.to_s if type == :true_false
      json
    end
  end
end
