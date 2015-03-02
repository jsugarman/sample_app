class Relationship < ActiveRecord::Base

	# 
	# NOTE: follower id attribute should not be accessible
	# 		but will need implmenting in controller
	# 
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"

	# 
	# validations
	# 
	validates :follower, presence: true 
	validates :followed, presence: true 


end
