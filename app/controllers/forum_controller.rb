class ForumController < ApplicationController
  class << self
    attr_accessor :klass
  end

  def index
    @posts = Post.includes(:author).select(*%i[id author_id title created_at votes visits]).all
  end

  def featured
    @posts = Post.includes(:author).featured.select(*%i[id author_id title created_at votes visits]).all
    render 'forum/index'
  end

  def vote_post
    vote(Post)
  end

  def vote_comment
    vote(Comment)
  end

  def vote_reply
    vote(Reply)
  end
end
