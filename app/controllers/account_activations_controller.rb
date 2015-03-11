class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		activation_token = params[:id]
		if user  \
		and user.authenticated?(activation_token) \
		and not user.activated?		
			then 
			user.update_attribute(:activated, true)
			user.update_attribute(:activated_at, Time.zone.now)
			sign_in user
			flash[:success] = "Activation Succeeded!"
			redirect_to user
		else 
			flash[:failure] = "Activation Failed - invalid user, activation token or already activated!"
			redirect_to root_url
		end

	end

end
