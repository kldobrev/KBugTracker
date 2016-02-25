class Tag < ActiveRecord::Base
	
	validates :name, presence: true, length: {minimum: 3}, uniqueness: true, format: {with: /[a-z]{3,}/, message: "The tag name should contain only alphabetic characters."}
	has_and_belongs_to_many :projects

end
