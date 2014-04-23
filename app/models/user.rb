class User < ActiveRecord::Base

	#bcrypt-ruby Gem add-in method
	has_secure_password

	#before insert,update,delete triggers
	before_save{ email.downcase! }

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

	

end
