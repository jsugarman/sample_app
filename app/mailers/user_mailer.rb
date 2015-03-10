class UserMailer < ActionMailer::Base
	default :from => "rortestmailer@gmail.com"

	def registration_confirmation(user)
		@user = user
		mail(:to => user.email, :subject => "Sample App Registration Confirmation" )
	end

end
