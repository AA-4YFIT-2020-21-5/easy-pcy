# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  author_id  :bigint           not null
#  title      :string
#  content    :text
#  votes      :jsonb
#  last_edit  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  visits     :bigint           default(0), not null
#
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  scope :featured, -> { includes(author: :role).where(author: { roles: { name: "SYSTEM" } }) }

  has_author
  has_votes
end
