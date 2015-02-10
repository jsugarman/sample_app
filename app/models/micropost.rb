class Micropost < ActiveRecord::Base

	# no longer needed in rails 4
	# attr_accessible :content, :user_id 
	validates :user_id, presence: true
end
