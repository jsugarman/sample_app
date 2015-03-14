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
		@user = User.find_by(email: params[:email])

		if @user \
		and @user.authenticated?(reset, params[:id])
			then
			sign_in user
			render edit_password_reset_path(@user)
		else
			flash[:danger] = "Password Reset edit failed - invalid reset token or invalid user!"
			redirect_to root_url
		end
  	end

	# 
  	# on submit of password reset form
  	# 
  	def update
  		@user = User.find_by(params[:id])
  		# TODO
  		if @user
  			# TODO digest the password, update the password_digest, confirm reset, sign in
  			# @user.reset_password
  			@user.update_attribute(users_params)
  		else
  			flash[:failure] = "Failed to reset password"
  			redirect_to root_url
  		end	
  			
  	end

private

	def user_params
		params.require(:user).permit(:password, :password_confirmation)
	end


end
