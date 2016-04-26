class User < ActiveRecord::Base

	has_secure_password
	
	validates :username, presence: true, length: {minimum: 5}, uniqueness: true
	validates :email, presence: true, format: {with: /[a-zA-Z0-9]{2,}[\w]*\@\w{2,}\.[a-z]{2,}/, message: "Not a valid email address."}, uniqueness: true
	validates :password_digest, length: {minimum: 8}
	validates :acctype, presence: true, inclusion: [0, 1]
	validates :is_pr_creator, presence: true, inclusion: [0, 1]
	
	has_many :projects
        has_many :made_requests, class_name: "Request", foreign_key: "from_usr_id"
        has_many :received_requests, class_name: "Request", foreign_key: "to_usr_id"
        has_many :members
	
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

        def is_proj_owner?
          self.projects.size != 0
        end

        def made_join_request?(project)
          request_exists?(project, 0)
        end
        
        def invited_to_proj_request?(project)
          request_exists?(project, 1)
        end

        def change_ownership_request?(project)
          request_exists?(project, 2)
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
        
        def is_admin?
          self.members.any? {|mem| mem.project.is_proj_admin?(self)}
        end

        def get_administered
          administered = self.members.map {|mem| mem.project if mem.project.is_proj_admin?(self)}
          administered.select {|pr| pr != nil}
        end

        private

        def request_exists?(proj, type)
          case type
            when 0
              Request.exists?(from_usr_id: self.id, proj_id: proj.id, req_type: type)
            when 1
              Request.exists?(to_usr_id: self.id, proj_id: proj.id, req_type: type)
            when 2
              Request.exists?(to_usr_id: self.id, proj_id: proj.id, req_type: type)
          end
        end


end
