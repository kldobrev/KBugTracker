class Request < ActiveRecord::Base

  validates :from_usr_id, presence: true
  validates :to_usr_id, presence: true
  validates :proj_id, presence: true
  validates :req_type, presence: true, inclusion: [0, 1, 2]
  validate :is_inverse_request 
  validate :is_duplicate_request

  belongs_to :creator, class_name: "User", foreign_key: "from_usr_id"
  belongs_to :receiver, class_name: "User", foreign_key: "to_usr_id"
  belongs_to :project, foreign_key: "proj_id"

  def is_join_req?
    self.req_type == 0
  end

  def is_invitation?
    self.req_type == 1
  end

  def is_ownership_req?
    self.req_type == 2
  end

  private

  def is_inverse_request
    if [0, 1].include? self.req_type
      inverse_type = (self.req_type == 0) ? 1 : 0 
      inv_req_exists = Request.exists?(proj_id: self.proj_id, from_usr_id: self.to_usr_id, to_usr_id: self.from_usr_id, req_type: inverse_type)
      errors[:base] << "An inverse request to this one already exists." if inv_req_exists
    end
  end

  def is_duplicate_request
    if Request.exists?(from_usr_id: self.from_usr_id, to_usr_id: self.to_usr_id, proj_id: self.proj_id, req_type: self.req_type)
      errors[:base] << "Another request with the same parameters already exists."
    end
  end

end

