module CourseData
  module DatabaseSeeder
    class << self
      def seed_default_courses
        create_course(CourseData::FileSystemParser.parse_courses)
      end

      def clear_default_courses
        ::Course
          .where(
            handle: CourseData::FileSystemParser.parse_courses.map(&:handle),
            author_id: CourseData.default_author_id)
          .destroy_all
      end

      def create_course(course, author_id = CourseData.default_author_id)
        course = [course] unless course.is_a?(Array)
        course.map { |c| ::Course.create(course_params(c, author_id)) }
      end

      def course_params(course, author_id)
        { author_id: author_id, handle: course.handle, title: course.title,
          chapters_attributes: course.chapters.map { |chapter| chapter_params(chapter) } }
      end

      def chapter_params(chapter)
        { handle: chapter.handle, title: chapter.title, content: chapter.text, quiz: chapter.quiz.to_json,
          image: read_image(chapter), external_video: chapter.video }
      end

      def read_image(chapter)
        return nil if chapter.media_files.empty?

        images = chapter.media_files.map do |img|
          image_path = chapter.path.join(img)
          bin = image_path.read.force_encoding(Encoding::BINARY)
          Base64.encode64(bin)
        end
        images.join(':')
      end

      def clear_courses(author_id = CourseData.default_author_id)
        Course.destroy(author_id: author_id)
      end
    end
  end
end
