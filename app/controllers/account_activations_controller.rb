class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		if user  \
		and user.authenticated?(:activation, params[:id]) \
		and not user.activated?		
			then 
			user.activate
			sign_in user
			flash[:success] = "Account activated!"			
			redirect_to user			
		else 
			flash[:danger] = "Activation Failed - invalid user, invalid token or already activated!"
			redirect_to root_url
		end

	end

end
