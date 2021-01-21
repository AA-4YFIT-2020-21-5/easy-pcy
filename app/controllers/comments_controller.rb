class CommentsController < ApplicationController

  before_action only: %i[update destroy vote] do
    @comment = Comment.find(params[:id]) if params.key?(:id)
  end

  def create
    return unless require_login(api: false)

    post = Post.find(params[:post_id])

    comment = post.comments.create!(
      params
        .require(:comment)
        .permit(*%i[content])
        .merge({author: @user}))

    Activity.create_from_object(comment)

    redirect_to post_path(post.id)
  end

  def update
    return unless require_login(api: false)

    return raise_not_found unless @comment
    return head(:unauthorized) unless @comment.author == @user

    comment_params = params.require(:person).permit(*%i[title content])
    comment_params.merge!(last_edit: Time.now)
    @comment.update!(comment_params)

    Activity.create_from_object(comment, 'edit')

    redirect_to post_path(post.id)
  end

  def destroy
    return unless require_login(api: true)

    return raise_not_found unless @comment
    return head(:unauthorized) unless @comment.author == @user || @user.moderator?

    @comment.destroy!
    redirect_to post_path(@comment.post_id)
  end

  def vote
    return unless require_login(api: true)

    vote = ActiveModel::Type::Boolean.new.cast(params.require(:vote))
    if vote.nil?
      flash[:error] = 'Invalid vote'
      head :bad_request
      return
    end

    @comment.vote(@user.id, vote)
    @comment.save!

    redirect_to post_path(@comment.post_id)
  end
end
