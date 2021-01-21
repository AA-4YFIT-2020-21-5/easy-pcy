# == Schema Information
#
# Table name: activity
#
#  id        :bigint           not null, primary key
#  user_id   :bigint           not null
#  type      :string
#  object_id :bigint
#  action    :string
#  timestamp :datetime
#
class Activity < ApplicationRecord
  self.table_name = 'activity'
  self.inheritance_column = nil

  # @param [User] user
  def self.fetch_user_activity(user)
    user = User.find(user) if user.is_a?(Integer)
    return [] if user.hide_course_activity && user.hide_forum_activity

    query = Activity.where(user_id: user.id)
    query =
      if user.hide_forum_activity
        query.where(type: %w[course chapter])
      elsif user.hide_course_activity
        query.where(type: %w[post comment reply])
      else
        query
      end

    query.order(:timestamp).all
  end

  def self.create_from_object(object, action = 'create')
    raise ArgumentError, 'invalid object passed' unless object.respond_to?(:author_id) && object.respond_to?(:id)
    Activity.create(
      user_id: object.author_id, object_id: object.id,
      type: object.class.name.downcase, action: action)
  end

  def self.create_complete_activity(id, type, user_id)
    Activity.create(user_id: user_id, object_id: id, type: type, action: 'complete')
  end

  def self.create_100pct_activity(user_id)
    Activity.create(user_id: user_id, type: 'course', action: '100%')
  end

  def self.clear_user_activity(user_id)
    Activity.where(user_id: user_id).destroy_all
  end

  def self.serialize_user_activity(user_id)
    Activity
      .where(user_id: user_id)
      .order(:timestamp)
      .map { |a| a.slice(%i[timestamp type object_id action]) }
      .to_json
  end
end
