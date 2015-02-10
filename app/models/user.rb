class User < ActiveRecord::Base

	#bcrypt-ruby Gem add-in method
	has_secure_password

	has_many :microposts, -> { order 'created_at desc' }

	#before insert,update,delete triggers
	before_save{ self.email.downcase! }

	before_create :create_remember_token

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

		
	def User.new_remember_token
		return SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		return Digest::SHA1.hexdigest(token.to_s)
	end


private


	def create_remember_token
		# create secure token for permananet signin between sessions
		self.remember_token = User.digest(User.new_remember_token)
	end

end
