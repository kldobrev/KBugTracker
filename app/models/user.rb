class User < ActiveRecord::Base

	has_secure_password
	
	validates :username, presence: true, length: { minimum: 5 }, uniqueness: true
	validates :email, presence: true, format: { with: /[a-zA-Z0-9]{2,}[\w]*\@\w{2,}\.[a-z]{2,}/, message: "Not a valid email address." }, uniqueness: true
	validates :password_digest, length: { minimum: 8 }
	validates :acctype, presence: true, inclusion: [0, 1]
	
	def isPublic?
		self.type == 0
	end
	
	def isPrivate?
		not isPublic?
	end

end
