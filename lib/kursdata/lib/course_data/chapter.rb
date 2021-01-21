# frozen_string_literal: true

module CourseData
  class Chapter
    def initialize(path, handle, title, text, quiz, video = nil, media_files = [])
      @path = path
      @handle = handle
      @title = title
      @text = text
      @quiz = quiz
      @video = video
      @media_files = media_files
    end

    attr_reader :path, :handle, :title, :text, :quiz, :video, :media_files
  end
end
