class Member < ActiveRecord::Base

  belongs_to :user
  belongs_to :project 

  has_many :group_members
  has_many :groups, through: :group_members

end
