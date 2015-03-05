class Micropost < ActiveRecord::Base

	# no longer needed in rails 4: see controller for protecting attributes
	# attr_accessible :content , :user_id 
	belongs_to :user

	# default_scope -> { order_by(:created_at => :desc) }
	scope :microposts, -> { order(created_at: :desc) }



	validates :user_id,
				 presence: true

	validates :content,
				length: {maximum: 140},
				presence: true

	def self.user_feed(user)
		# 
		#  longest and manual version - see below for safer method using rails helpers
		# 
		# rails helpers provide a singularized version of model methods defined 
		# through "has_many" that can be suffixed with "_ids" to return an array
		# of he individual items. further, interpolation into the ? of the sql  
		# this as a comma-delimited database agnostice string
		# 
		# fuids = user.followed_users.map { |u|  u.id.to_s }.join(', ')		
		# Micropost.where('microposts.user_id in (?) or microposts.user_id = ? ',
		# 				fuids,
		# 	 			user.id)

		# 
		# shortest and most scalable (heavy lifting done by database set theory) version 
		# 
		where(	'user_id in ('\
							'select r.followed_id '\
							'from relationships r '\
							'where r.follower_id = :user_id '\
							') '\
				 'or user_id = :user_id '\
				 ,user_id: user.id) .order(created_at:  :desc)
	end

end
