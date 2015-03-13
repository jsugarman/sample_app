class PasswordResetsController < ApplicationController
  

  def new
	@title = "Forgotten Password"
  end

  def edit
  	@title = "Reset Password"
  	user = User.find_by(email: params[:email])

  	if user \
  	and user.authenticated?(params[:id])
  		then
  		# TODO render update
  	else

  	end

  end

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

end
