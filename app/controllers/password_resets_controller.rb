class PasswordResetsController < ApplicationController

	# 
	# callbacks/declarative
	# 
	before_action :get_user, 			only: [:edit, :update]
	before_action :valid_user,			only: [:edit, :update]
 	before_action :check_expiration, 	only: [:edit, :update]
  
	# 
	# on click of forgottem password link
	# 
	def new
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
	# NOTE: reset token only available in form params reliably
	# 
	def edit
  	end

	# 
  	# on submit of ../password_resets/edit.html.erb form
  	# 
  	def update
  		if password_blank? 
  			flash.now[:danger] = "Password reset failed - password blank!"
  			render 'edit'
  		elsif @user.reset_password(user_params)
  			sign_in @user
  			flash[:success] = "Password reset successfully!"
  			redirect_to @user
  		else
  			# form error, no flash should be displayed
  			render 'edit'
  		end	
  	end

private

	def user_params
		params.require(:user).permit(:password, :password_confirmation)
	end

	def password_blank?
 		params[:user][:password].blank?
	end

	def get_user
		@user = User.find_by(email: params[:email])
	end

	def valid_user
		unless (@user && 
			@user.activated? && 
			@user.authenticated?(:reset, params[:id])
				)
			flash[:error] = "Password reset failed - invalid, unactivated or unauthenticated user!"
			redirect_to root_url
		end
	end

	def check_expiration
		if @user.password_reset_expired?
			flash[:danger] = "Password reset failed - time limit expired!"
			redirect_to root_url
		end
	end

end
