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

end
