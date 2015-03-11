class User < ActiveRecord::Base

	attr_accessor :activation_token

	#bcrypt-ruby Gem add-in method
	has_secure_password

	has_many :microposts, -> { order 'created_at desc' }, dependent: :destroy

	# 
	# relationships table containts 2 foreign keys to users table
	#  - the follower id cannot be changed, the followed can be
	#  - if the  user is destroyed so to is any record of whom they are following
	#  
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed

	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	#before insert,update,delete triggers
	before_save{ self.email.downcase! }

	before_create :create_remember_token
	before_create :create_activation_digest

	validates 	:name,
				presence: true,
				length: { maximum: 64 }
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

  	validates 	:email,
				presence: true,
				format: { with: VALID_EMAIL_REGEX },
				uniqueness: {case_sensitive: false} 

	validates	:password,
				length: { minimum: 6}
				# presence: { on: create }

		
	def User.new_token
		return SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		return Digest::SHA1.hexdigest(token.to_s)
	end

	def authenticated?(activation_token)
		if self.activation_digest.nil?
			return false
		else
			return User.digest(activation_token) == self.activation_digest
		end
	end

	def feed
		Micropost.user_feed(self)
	end

	def follow!(other_user)
		self.relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		self.relationships.find_by_followed_id(other_user.id).destroy!	
	end

	def following?(other_user)
		# relationships.where('follower_id = ? and followed_id = ?', id, other_user.id )
		self.relationships.find_by_followed_id(other_user.id)
	end

private

	def create_remember_token
		# create secure token for permananet signin between sessions
		self.remember_token = User.new_token
	end

	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

end
