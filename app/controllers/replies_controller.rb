class RepliesController < ApplicationController

  before_action only: %i[update destroy vote filter] do
    @reply = Reply.find(params[:id]) if params.key?(:id)
  end

  def create
    return unless require_login(api: false)

    comment = Comment.includes(:post).find(params[:comment_id])

    reply = comment.replies.create!(
      params
        .require(:reply)
        .permit(*%i[content])
        .merge({author: @user}))

    Activity.create_from_object(reply)

    redirect_to post_path(comment.post_id)
  end

  def update
    return unless require_login(api: false)

    return raise_not_found unless @reply
    return head(:unauthorized) unless @reply.author == @user

    reply_params = params.require(:reply).permit(:content)
    reply_params.merge!(last_edit: Time.now)
    @reply.update!(reply_params)

    redirect_to post_path(comment.post_id)
  end

  def destroy
    return unless require_login(api: true)

    return raise_not_found unless @reply
    return head(:unauthorized) unless @reply.author == @user || @user.moderator?

    @reply.destroy!

    redirect_to post_path(@reply.comment.post_id)
  end

  def vote
    return unless require_login(api: true)

    vote = ActiveModel::Type::Boolean.new.cast(params.require(:vote))
    if vote.nil?
      flash[:error] = 'Invalid vote'
      head :bad_request
      return
    end

    @reply.vote(@user.id, vote)
    @reply.save!

    redirect_to post_path(@reply.comment.post_id)
  end
end
