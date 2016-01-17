class User < ActiveRecord::Base

	has_secure_password
	
	validates :username, presence: true, length: { minimum: 5 }, uniqueness: true
	validates :email, presence: true, format: { with: /[a-zA-Z0-9]{2,}[\w]*\@\w{2,}\.[a-z]{2,}/, message: "Not a valid email address." }, uniqueness: true
	validates :password_digest, length: { minimum: 8 }
	validates :acctype, presence: true, inclusion: [ 0, 1 ]
	validates :is_pr_creator, presence: true, inclusion: [ 0, 1 ]
	
	def is_public?
		self.acctype == 0
	end
	
	def is_private?
		not isPublic?
	end
	
	def is_activated?
		self.act_code == nil
	end
	
	def is_proj_creator?
		self.is_pr_creator == 1
	end

end
