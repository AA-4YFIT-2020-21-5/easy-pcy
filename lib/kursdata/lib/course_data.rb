# frozen_string_literal: true

module CourseData
  require 'course_data/chapter'
  require 'course_data/course'
  require 'course_data/quiz'
  require 'course_data/file_system_parser'

  ACRONYMS = %w[USB IO GPU CPU RAM SATA PSU HDD SSD USB2 USB3].freeze

  TF_CHARS = { '✔' => true, 'x' => false, true => '✔', false => 'x' }.freeze
  TF_STRING = { 'Wahr' => true, 'Falsch' => false, true => 'Wahr', false => 'Falsch' }.freeze

  singleton_class.attr_accessor :default_author_id
end


ActiveSupport::Inflector.inflections do |inf|
  CourseData::ACRONYMS.each { inf.acronym _1 }
end
