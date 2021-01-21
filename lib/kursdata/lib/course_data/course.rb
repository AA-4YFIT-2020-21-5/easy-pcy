# frozen_string_literal: true

module CourseData
  class Course
    def initialize(path, handle, title, chapters = [])
      @path = path
      @handle = handle
      @title = title
      @chapters = chapters
    end

    attr_reader :path, :handle, :title, :chapters
  end
end
