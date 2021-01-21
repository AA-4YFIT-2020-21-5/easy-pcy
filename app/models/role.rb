# == Schema Information
#
# Table name: roles
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  moderation_privileges     :boolean
#  administration_privileges :boolean
#
class Role < ApplicationRecord
end
