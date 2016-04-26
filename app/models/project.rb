class Project < ActiveRecord::Base

	before_validation :default_values

	validates :title, presence: true, length: {minimum: 3}, uniqueness: true
	validates :prtype, presence: true, inclusion: [0, 1]
	
	belongs_to :user
	has_and_belongs_to_many :tags, -> {order "name ASC"}
        has_many :groups
        has_many :members
        has_many :requests, foreign_key: "proj_id"

        accepts_nested_attributes_for :groups, allow_destroy: true
        accepts_nested_attributes_for :tags, allow_destroy: true
	
	def is_public?
		self.prtype == 0
	end
	
	def is_private?
		not is_public?
	end

        def is_member?(user)
          self.members.any? {|mem| mem.user == user}
        end

        def has_admin_group?
          self.groups.exists?(administrative: 1)
        end

        def is_proj_admin?(user)
          self.is_member?(user) && self.groups.any? {|gr| gr.is_administrative? && gr.is_group_member?(user)}
        end

        def is_proj_owner?(user)
          self.user == user
        end

	private
	
	def default_values
		self.prtype ||= 0
	end
	
	def self.search(query, descr_flg, pr_type)
		return {} if query.blank?
		type_fltr = ["0", "1"].include?(pr_type) ? "prtype=#{pr_type} and" : ""
		if descr_flg == "1"
			Project.where("#{type_fltr} (title LIKE :qry or description LIKE :qry)", qry: "%#{query}%").order(prtype: :desc)
		else
			Project.where("#{type_fltr} title LIKE ?", "%#{query}%").order(prtype: :desc)
		end
	end
	
end
