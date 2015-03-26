class User < ActiveRecord::Base

	attr_accessor :remember_token, :activation_token, :reset_token

	# hooks
	before_save{ self.email.downcase! }
	before_create :create_remember_digest
	before_create :create_activation_digest

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

	def authenticated?(attribute, token)
		digest = self.send("#{attribute}_digest")
		if digest.nil?
			return false
		else
			return User.digest(token) == digest
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

	def activate
		self.update_attribute(:activated, true)
		self.update_attribute(:activated_at, Time.zone.now)
	end

	def send_activation_email
		UserMailer.account_activation(self).deliver
	end

	def send_password_reset_email
		UserMailer.password_reset(self).deliver
	end

	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(self.reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	def reset_password(reset_params)
		# 
		# extend the passed in params hash 
		# (containing the password and password confirmation 
		# hash elements) with a null reset_digest in order to 
		# invalidate any futre attempts at resetting using that 
		# hash extending the hash allows one call and saved update
		# on the db.
		# 
		reset_params[:reset_digest] = ''
		update_attributes(reset_params)
	end

	def password_reset_expired?
		return reset_sent_at < 2.hours.ago
	end

private

	def create_remember_digest
		# create secure token for permananet signin between sessions
		self.remember_token = User.new_token
		self.remember_digest = User.digest(self.remember_token)
	end

	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

end
