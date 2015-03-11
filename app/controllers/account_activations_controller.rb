class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		activation_token = params[:id]
		if user  \
		and user.authenticated?(activation_token) \
		and not user.activated?		
			then 
			user.activate
			sign_in user
			flash[:success] = "Account activated!"
			redirect_to user
		else 
			flash[:dnager] = "Activation Failed - invalid user, activation token or already activated!"
			redirect_to root_url
		end

	end

end
