class Micropost < ActiveRecord::Base


	attr_accessible :content
	belongs_to :user
	# no longer needed in rails 4
	# attr_accessible :content, :user_id 
	validates :user_id, presence: true

	validates :content,
				length {maximum 140}
end
