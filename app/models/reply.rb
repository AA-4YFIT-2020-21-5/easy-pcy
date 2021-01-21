# == Schema Information
#
# Table name: replies
#
#  id         :bigint           not null, primary key
#  author_id  :bigint           not null
#  comment_id :bigint           not null
#  content    :text
#  votes      :jsonb
#  last_edit  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Reply < ApplicationRecord
  belongs_to :comment

  has_author
  has_votes

  def post
    comment.post
  end

  def from_post_author?
    author.id == comment.post.author.id
  end

  def from_comment_author?
    author.id == comment.author.id
  end
end
