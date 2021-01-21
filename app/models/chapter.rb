# == Schema Information
#
# Table name: chapters
#
#  id             :bigint           not null, primary key
#  course_id      :bigint           not null
#  handle         :string
#  title          :string
#  content        :text
#  quiz           :jsonb
#  image          :string
#  external_video :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Chapter < ApplicationRecord
  belongs_to :course

  def images
    (self[:image] || '').split(':')
  end

  def image_sources
    images.map { |base64| "data:image/png;base64, #{base64}" }
  end

  def video?
    !self[:external_video].nil?
  end

  def youtube_url
    "https://www.youtube-nocookie.com/embed/" + self[:external_video] if video?
  end

  def quiz
    return @cd_quiz if @cd_quiz
    q = self[:quiz]
    @cd_quiz = CourseData::Quiz.new(
      prompt: q['prompt'], type: q['type'],
      solution: q['answer'], options: q['options'])
  end
end
