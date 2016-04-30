class GroupMember < ActiveRecord::Base

  belongs_to :group
  belongs_to :member

  validates :member, uniqueness: {scope: :group, message: "This user is already a member of this group."}  

end

