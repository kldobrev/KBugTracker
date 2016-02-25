class User < ActiveRecord::Base

	has_secure_password
	
	validates :username, presence: true, length: {minimum: 5}, uniqueness: true
	validates :email, presence: true, format: {with: /[a-zA-Z0-9]{2,}[\w]*\@\w{2,}\.[a-z]{2,}/, message: "Not a valid email address."}, uniqueness: true
	validates :password_digest, length: {minimum: 8}
	validates :acctype, presence: true, inclusion: [0, 1]
	validates :is_pr_creator, presence: true, inclusion: [0, 1]
	
	has_many :projects
	
	def is_public?
		self.acctype == 0
	end
	
	def is_private?
		not is_public?
	end
	
	def is_activated?
		self.act_code == nil
	end
	
	def is_proj_creator?
		self.is_pr_creator == 1
	end
	
	def self.search(usr_name, fst_name, lst_name, usr_type)
		return {} unless usr_name.present? or fst_name.present? or lst_name.present?
		type_fltr = (["0", "1"].include? usr_type) ? "acctype=#{usr_type} and" : ""
		if usr_name.present?
			User.where("#{type_fltr} username LIKE ?", "%#{usr_name}%").order(acctype: :desc)
		elsif fst_name.present? && lst_name.present?
			User.where("#{type_fltr} ((firstname LIKE :fst and lastname LIKE :lst) or firstname LIKE :fst or lastname like :lst)", 
				fst: "%#{fst_name}%", lst: "%#{lst_name}%").order(acctype: :desc)
		elsif fst_name.present?
			User.where("#{type_fltr} firstname LIKE ?", "%#{fst_name}%").order(acctype: :desc)
		else
			User.where("#{type_fltr} lastname LIKE ?", "%#{lst_name}%").order(acctype: :desc)
		end
	end

end
