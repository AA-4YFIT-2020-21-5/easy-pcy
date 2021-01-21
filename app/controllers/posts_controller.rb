class PostsController < ApplicationController

  before_action only: %i[update destroy vote] do
    @post = Post.find(params[:id]) if params.key?(:id)
  end

  def new
    return unless require_login(api: false)

    render 'forum/new'
  end

  def show
    @post = Post.find(params.require(:id))
    render 'forum/post'
  end

  def create
    return unless require_login(api: true)

    post = Post.create!(
      params
        .require(:post)
        .permit(*%i[title content])
        .merge({author: @user}))

    Activity.create_from_object(post)

    redirect_to post_path(post.id)
  end

  def update
    return unless require_login(api: true)

    @post = Post.find(params.require(:id))

    return raise_not_found unless @post
    return head(:unauthorized) unless @post.author == @user

    post_params = params.require(:post).permit(*%i[title content])
    post_params.merge!(last_edit: Time.now)
    @post.update!(post_params)

    redirect_to post_path(post.id)
  end

  def destroy
    return unless require_login(api: true)

    @post = Post.find(params.require(:id))

    return raise_not_found unless @post
    return head(:unauthorized) unless @post.author == @user || @user.moderator?

    @post.destroy!

    redirect_to forum_path
  end

  def vote
    return unless require_login(api: true)

    vote = ActiveModel::Type::Boolean.new.cast(params.require(:vote))
    if vote.nil?
      flash[:error] = 'Invalid vote'
      head :bad_request
      return
    end

    @post.vote(@user.id, vote)
    @post.save!

    redirect_to post_path(@post.id)
  end
end
