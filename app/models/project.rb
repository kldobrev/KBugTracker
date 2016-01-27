class Project < ActiveRecord::Base

	before_validation :default_values

	validates :title, presence: true, length: { minimum: 3 }
	validates :prtype, presence: true, inclusion: [ 0, 1 ]
	
	belongs_to :user
	
	def is_editor?(user)
		self.user == user
	end
	
	def is_public?
		self.prtype == 0
	end
	
	def is_private?
		not is_public?
	end
	
	private
	
	def default_values
		self.prtype ||= 0
	end

end
