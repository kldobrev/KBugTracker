class Defect < ActiveRecord::Base

  validates :title, presence: true, length: {minimum: 3} 
  validates :status, presence: true, inclusion: [0, 1, 2, 3]
  validates :importance, presence: true, inclusion: [0, 1, 2, 3]
  validate :is_assigned_to_user_or_group?

  belongs_to :project
  belongs_to :raised_by, class_name: "User"
  belongs_to :assigned_to, class_name: "User"
  belongs_to :to_group, class_name: "Group"

  def get_literal_status
    case(self.status)
      when 0 then "Opened"
      when 1 then "Maintenance"
      when 2 then "Closed"
      when 3 then "For deletion"
      else "Unknown"
    end
  end
  
  def get_literal_importance
    case(self.importance)
      when 0 then "Critical"
      when 1 then "High"
      when 2 then "Medium"
      when 3 then "Low"
      else "Unknown"
    end
  end

  def is_assigned_user?(user)
    if self.assigned_to.present?
      return self.assigned_to == user
    else
      return self.to_group.is_group_member?(user)
    end
  end

  def is_def_creator?(user)
    self.raised_by == user
  end

  def is_editable?
    not [2, 3].member? self.status
  end

  def has_delete_perm?(user)
    self.project.is_proj_admin?(user) || self.raised_by == user
  end

  private

  def is_assigned_to_user_or_group?
    self.assigned_to_id.present? or self.to_group_id.present?
  end

end

