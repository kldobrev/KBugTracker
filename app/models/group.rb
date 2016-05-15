class Group < ActiveRecord::Base

  validates :name, presence: true, length: {minimum: 2}, uniqueness: {scope: :project, message: "with the same name is already defined for this project."}
  validates :administrative, presence: true, inclusion: [0, 1]

  belongs_to :project
  has_many :group_members
  has_many :members, through: :group_members
  has_many :defects, foreign_key: "to_group_id"

  before_validation :default_values

  def is_administrative?
    self.administrative == 1
  end

  def is_group_member?(user)
    self.members.exists?(user_id: user.id)
  end

  private

  def default_values
    self.name ||= "Default"
    self.administrative ||= 0
  end

end

