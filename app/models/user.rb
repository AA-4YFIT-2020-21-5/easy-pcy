# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  email                :string
#  role_id              :bigint
#  display_name         :string
#  password_digest      :string
#  description          :text
#  hide_forum_activity  :boolean
#  hide_course_activity :boolean
#  progress             :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class User < ApplicationRecord
  belongs_to :role, optional: true

  has_secure_password

  after_initialize do
    @progress = ProgressInterface.new(self)
  end

  # @return [ProgressInterface]
  attr_reader :progress

  def verified?
    !role.nil?
  end

  def administrator?
    !!role&.administration_privileges
  end

  def moderator?
    !!role&.moderation_privileges
  end

  class ProgressInterface
    PROGRESS_VERSION = 1
    COURSES_COUNT = 12

    def initialize(user)
      @user = user
    end

    def clear
      user[:progress] = nil
    end

    def completed_courses
      interact

      progress.select { |_k, c| c == true }.keys
    end

    def completed_courses_percent
      interact

      completed_courses.count.to_f / COURSES_COUNT
    end

    def complete_course(course_handle)
      interact

      progress[course_handle] = true
    end

    def completed_chapters(course_handle)
      interact

      progress[course_handle] || []
    end

    def complete_chapter(course_handle, chapter_handle)
      interact

      return if completed_chapter?(course_handle, chapter_handle)

      progress[course_handle] ||= []
      progress[course_handle] << chapter_handle
    end

    def completed_course?(course_handle)
      interact

      progress[course_handle] == true
    end

    def completed_chapter?(course_handle, chapter_handle)
      interact

      completed_course?(course_handle) || progress[course_handle]&.include?(chapter_handle) || false
    end

    private

    attr_reader :user

    # only called if the progress field is used
    # to reduce load on server and unneccessary changes
    def interact
      user[:progress] ||= {}
      update_version unless version == PROGRESS_VERSION
    end

    def progress
      user[:progress]
    end

    def version
      progress['version'] || 0
    end

    def update_version
      original_version = version
      return (original_version..PROGRESS_VERSION) if original_version == PROGRESS_VERSION

      # TODO: changes to the format should be handled here

      progress['version'] = 1 if version < 1

      (original_version..PROGRESS_VERSION)
    end
  end
end
