class Micropost < ActiveRecord::Base

	belongs_to :user

	# default_scope -> { order_by(:created_at => :desc) }
	scope :microposts, -> { order(created_at: :desc) }

	# no longer needed in rails 4
	# attr_accessible :content, :user_id 

	validates :user_id, presence: true

	validates :content,
				length: {maximum: 140}
end
