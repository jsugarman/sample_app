class UserMailer < ActionMailer::Base

	include ApplicationHelper

	default :from => "rortestmailer@gmail.com"

	def registration_confirmation(user)
		@user = user
		mail(to:  "#{user.name} <#{user.email}>", subject: full_title("Registration Confirmation for #{user.name}"))
	end

	def account_activation(user)
		@user = user
		mail(to: "#{user.name} <#{user.email}>", subject: full_title("Activation Required for #{user.name}"))
	end

	def password_reset(user)
		@user = user
		mail(to: "#{user.name} <#{user.email}>", subject: full_title("Password reset requested for #{user.name}") )
	end

end
