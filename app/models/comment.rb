# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  author_id  :bigint           not null
#  post_id    :bigint           not null
#  content    :text
#  votes      :jsonb
#  last_edit  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :post
  has_many :replies, dependent: :destroy

  has_author
  has_votes

  def from_post_author?
    author.id == post.author.id
  end
end
