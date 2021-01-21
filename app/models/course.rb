# == Schema Information
#
# Table name: courses
#
#  id         :bigint           not null, primary key
#  author_id  :bigint           not null
#  handle     :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Course < ApplicationRecord
  has_many :chapters, dependent: :destroy
  accepts_nested_attributes_for :chapters
  has_author
end
