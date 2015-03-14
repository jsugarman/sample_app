class PasswordResetsController < ApplicationController
  
	# 
	# on click of forgottem password link
	# 
	def new
		@title = "Forgotten Password"
	end

	# 
	# on submit of forgottem password email address form
	# 
	def create
		email = params[:password_resets][:email].downcase
		@user = User.find_by(email: email)	

		if @user
			@user.create_reset_digest
			@user.send_password_reset_email
			flash[:info] = "Password reset confirmation sent to #{@user.email}."
			redirect_to root_url
		else
			flash[:danger] = "Specified email, #{email}, not found!"
			render new_password_reset_path
		end 
	end

	# 
	# called from mail link
	# 
	def edit
		@title = "Reset Password"
		reset_token = params[:id]
		@user = User.find_by(reset_digest: User.digest(reset_token)) # this authenticates in reality

		# NOTE: fairly pointless to authenticate
		# 		since the query identified them anyway
		if @user \
		and @user.activated? \
		and @user.authenticated?(:reset, reset_token)
		then
			@user.reset_token = reset_token #for debug only
			# allow default render iof path to complete
			# render edit_password_reset_url(params[:id],email: params[:email])

		else
			flash[:danger] = "Password Reset edit failed - invalid reset token, unactivated or invalid user!"
			redirect_to root_url
		end
  	end

	# 
  	# on submit of ../password_resets/edit.html.erb form
  	# 
  	def update
  		@user = User.find(params[:id])
  		if @user.reset_password(user_params)
  			sign_in @user
  			flash[:success] = "Password reset successfully!"
  			redirect_to @user
  		else
  			flash[:danger] = "Failed to reset password!"
  			render 'edit'
  		end	
  	end

private

	def user_params
		params.require(:user).permit(:password, :password_confirmation)
	end


end
