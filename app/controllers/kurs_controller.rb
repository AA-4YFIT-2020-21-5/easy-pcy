class KursController < ApplicationController

  def index
    # @type [Array<CourseData::Course>]
    @courses = Course.where(author_id: CourseData.default_author_id)
  end

  def kurs
    # @type [CourseData::Course]
    @course = Course.includes(:chapters).find_by(handle: params.require(:kurs))
    raise_not_found unless @course
  end

  def kapitel
    kurs

    # @type [CourseData::Chapter]
    @chapter = @course.chapters.find_by(handle: params.require(:kapitel))
    raise_not_found unless @chapter
  end

  def quiz
    kapitel

    # @type [CourseData::Quiz]
    @quiz = @chapter.quiz
  end

  def answer
    answer = params[:answer]

    if answer.nil?
      redirect_to "/kurs/#{@course.handle}/#{@chapter.handle}/quiz"
      return
    end

    quiz

    correct =
      case @quiz.type
      when :true_false
        @quiz.solution == ActiveModel::Type::Boolean.new.cast(answer)

      when :multiple_choice
        idx = answer.to_i
        # 1-based index; 0 => invalid answer
        idx.zero? ? nil : @quiz.solution == @quiz.options[idx - 1]

      when :text_input
        @quiz.solution.squish.downcase == answer.squish.downcase

      else
        @quiz.solution == answer
      end


    if correct
      if @user && !@user.progress.completed_chapter?(@course.handle, @chapter.handle)
        @user.progress.complete_chapter(@course.handle, @chapter.handle)
        Activity.create_complete_activity(@chapter.id, 'chapter', @user.id)
        all_handles = @course.chapters.map(&:handle)

        # check if all chapters in course are completed
        if (all_handles & @user.progress.completed_chapters(@course.handle)) == all_handles
          @user.progress.complete_course(@course.handle)
          Activity.create_complete_activity(@course.id, 'course', @user.id)
        end
        @user.save!
      end

      redirect_to "/kurs/#{@course.handle}/"
    else
      redirect_to "/kurs/#{@course.handle}/#{@chapter.handle}/quiz"
    end
  end

  def edit
    kapitel

    @chapter.update!(params.require(:chapter).permit(*%i[title content]))
  end

  def reset
    return unless require_login

    @user.progress.clear
    @user.save!

    redirect_back fallback_location: '/kurs'
  end
end
