class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.has_votes
    self.include VoteInterface
  end

  def self.has_author
    self.belongs_to :author, class_name: 'User'
  end

  module VoteInterface
    def votes
      raise ActiveModel::MissingAttributeError, 'missing attribute: votes' unless has_attribute?(:votes)
      self[:votes] ||= []
    end

    def vote(user_id, bool)
      bool ? add_vote(user_id) : remove_vote(user_id)
    end

    def add_vote(user_id)
      return false if user_voted?(user_id)
      votes << user_id
      true
    end

    def remove_vote(user_id)
      !!votes.delete(user_id)
    end

    def user_voted?(user_id)
      votes.include?(user_id)
    end
  end
end
