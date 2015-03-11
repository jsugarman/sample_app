class AccountActivationsController < ApplicationController


	def edit
		# find the 
		user = User.find_by(email: params[:email])
		token = params[:id]
		if user.activation_digest = User.digest(token)
			user.update_attribute(:activated, true)
			user.update_attribute(:activated_at, Time.zone.now)
			sign_in user
			flash[:success] = "Activation Succeeded!"
			redirect_to user
		else 
			flash[:failure] = "Error: invalid Activation token"
			redirect_to root_url
		end

	end

end
