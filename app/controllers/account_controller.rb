class AccountController < ApplicationController
  def index; end

  def profile
    user = params[:user] ? User.find_by(id: params[:user]) : current_user

    unless user
      flash[:notice] = 'Not logged in'
      redirect_to '/#login'
      return
    end

    # @type [User]
    @user_profile = user

    @activities = Activity.fetch_user_activity(@user).map do |activity|
      includes =
        case activity.type
        when 'reply' then :comment
        when 'chapter' then :course
        else []
        end
      klass =
        activity
          .type
          .camelize
          .constantize
      query = klass
      query = query.includes(includes) unless includes.empty?
      object = query.find(activity.object_id) rescue next
      [
        ((object&.title || next) rescue next),
        case activity.type
        when 'post' then post_url(object.id)
        when 'comment' then post_url(object.post_id)
        when 'reply' then post_url(object.comment.post_id)
        when 'course' then "/kurs/#{object.handle}"
        when 'chapter' then "/kurs/#{object.course.handle}/#{object.handle}"
        else next
        end,
        activity.timestamp
      ]
    rescue
      nil
    end.compact || []
  end

  def login
    if (user = User.find_by(email: params.require(:email)))&.authenticate(params.require(:password))
      session[:user_id] = user.id

      redirect_back fallback_location: '/'
    else
      flash[:login] = 'Anmeldung fehlgeschlagen'
      redirect_back fallback_location: '/#login'
    end
  end

  def register
    if User.find_by(email: params.require(:email))
      # email already used
      flash[:register] = 'Registrierung fehlgeschlagen'
      redirect_back fallback_location: '/#register'
    else
      user = User.new(
        email: params.require(:email),
        password: params.require(:password),
        password_confirmation: params.require(:password_confirmation),
        display_name: params.require(:name)
      )

      if user.save
        session[:user_id] = user.id
        redirect_back fallback_location: '/'
      else
        flash[:register] = 'Registrierung fehlgeschlagen'
        puts user.errors.messages
        redirect_back fallback_location: '/#register'
      end
    end
  end

  def edit
    return unless require_login

    hsh = {}
    hsh[:display_name] = params[:new_name] if params[:new_name]
    hsh[:description] = params[:new_description] if params[:new_description]

    unless hsh.empty?
      @user.update!(hsh)
    end

    redirect_to profile_path
  end

  def change_password
    return unless require_login

    hsh = {
      password: params.require(:new_password),
      password_confirmation: params.require(:new_password_confirmation)
    }
    old = params.require(:password)
    @user.update!(hsh) if @user.authenticate(old)

    redirect_back fallback_location: '/'
  end

  def logout
    session[:user_id] = nil
    reset_session
    redirect_back fallback_location: '/'
  end

  def settings
    unless @user
      flash[:notice] = 'Nicht angemeldet'
      redirect_back fallback_location: '/#login'
    end

    option = params.require(:option).to_sym
    value = params.require(:value)

    case option
    when :hide_forum_activity
      value = ActiveModel::Type::Boolean.new.cast(value)
      @user.update!(hide_forum_activity: value)
      head :ok

    when :hide_course_activity
      value = ActiveModel::Type::Boolean.new.cast(value)
      @user.update!(hide_course_activity: value)
      head :ok

    else
      head :bad_request
    end
  end
end
