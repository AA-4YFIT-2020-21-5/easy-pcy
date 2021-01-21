# frozen_string_literal: true

module CourseData
  module FileSystemParser
    class << self
      def parse(dir)
        courses = Pathname(dir).each_child.map do |pn|
          next unless HANDLE_REGEXP.match?(pn.basename.to_s)
          next if pn.basename.to_s == '13_os'

          parse_course(pn)
        end
        sort_index_array(courses)
      end

      def parse_courses(path = "#{Rails.root}/lib/kursdata/data")
        CourseData::FileSystemParser.parse(path)
      end

      def parse_course(pathname)
        basename = pathname.basename.to_s

        index, handle, title = parse_basename(basename)
        title_file, chapters = parse_course_files(pathname)

        course = CourseData::Course.new(pathname, handle, title_file || title)

        sort_index_array(course.chapters.concat(chapters))

        [index, course]
      end

      def parse_course_files(pathname)
        title = nil
        chapters = []
        pathname.each_child do |pn|
          next title = pn.read.strip if pn.basename.to_s == 'title.txt'
          next unless HANDLE_REGEXP.match?(pn.basename.to_s)

          chapters << parse_chapter(pn)
        end
        [title, chapters]
      end

      def parse_chapter(pathname)
        basename = pathname.basename.to_s

        index, handle = parse_basename(basename)

        text, quiz, video, media = parse_chapter_files(pathname)
        text = text.lines(chomp: true)
        title = text.shift
        text = text.join("\n")

        raise ArgumentError, "text.txt and quiz.txt must be present (#{pathname})" if text.nil? || quiz.nil?

        [index, CourseData::Chapter.new(pathname, handle, title, text, quiz, video, media)]
      end

      def parse_basename(basename)
        match = basename.to_s.match(HANDLE_REGEXP)
        index = match[:index].to_i
        handle = match[:handle].parameterize
        title = handle_to_title(match[:handle])
        [index, handle, title]
      end

      def handle_to_title(handle)
        index = handle.rindex('_')
        return handle.titleize unless index

        num = Integer(handle[(index+1)..]) rescue nil
        return handle.titleize unless num

        "#{handle[...index].titleize} #{num.to_roman}"
      end

      def parse_chapter_files(pathname)
        text, quiz, video = nil
        media = []
        pathname.each_child do |pn|
          case pn.basename.to_s
          when 'text.txt' then text = pn.read.gsub(/[\r\n]+/, "\n")
          when 'quiz.txt' then quiz = parse_quiz(pn.read)
          when 'video.txt' then video = pn.read.strip
          else media << pn.basename.to_s
          end
        end
        [text, quiz, video, media]
      end

      def parse_quiz(quiz_content)
        lines = quiz_content.lines.map(&:strip).reject(&:empty?)
        return false if lines.empty?

        quiz = nil
        QUIZ_PARSERS.each do |parser|
          break if (quiz = parser.call(lines))
        end
        quiz
      end

      def sort_index_array(arr)
        arr.compact!
        arr.sort! { |(a_idx,_), (b_idx,_)| a_idx <=> b_idx }
        arr.map!(&:last)
        arr
      end
    end


    HANDLE_REGEXP = /\A(?<index>\d+)_(?<handle>[\w\d_-ÄäÖöÜüß]+)\z/.freeze

    QUIZ_PARSERS = [
      proc do |lines|
        next false unless lines.length == 2
        next false unless lines.first.match?(/_{3}/)

        CourseData::Quiz.new(type: :text_input, prompt: lines.first, solution: lines.last)
      end,
      proc do |lines|
        next false unless lines.length == 3
        next false unless lines[1..2].all? { |l| l.match?(TF_QUIZ_REGEX) }

        options = lines[1..].map do |l|
          match = l.match(TF_QUIZ_REGEX)
          next [TF_CHARS[match[:correct]], TF_STRING[match[:option]]]
        end

        # find option where :correct is true and get :option
        correct_option = options.find(&:first).last

        CourseData::Quiz.new(
          type: :true_false, prompt: lines.first,
          solution: correct_option, options: options.map(&:last)
        )
      end,
      proc do |lines|
        next false unless lines.length > 2
        next false unless lines[1..].all? { |l| l.match?(MC_QUIZ_REGEX) }

        options = lines[1..].map do |l|
          match = l.match(MC_QUIZ_REGEX)
          next [TF_CHARS[match[:correct]], match[:option]]
        end

        # find option where :correct is true and get :option
        correct_option = options.find(&:first).last

        CourseData::Quiz.new(
          type: :multiple_choice, prompt: lines.first,
          solution: correct_option, options: options.map(&:last)
        )
      end,
      proc do |lines|
        CourseData::Quiz.new(type: :fallback, prompt: lines.join("\n"))
      end
    ].freeze

    TF_QUIZ_REGEX = /\A(?<correct>[✔x]) (?<option>Wahr|Falsch)/.freeze
    MC_QUIZ_REGEX = /\A(?<correct>[✔x]) (?<option>.*)/.freeze
  end
end
