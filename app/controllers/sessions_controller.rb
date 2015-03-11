class SessionsController < ApplicationController

  def new
    # TODO should render a captcha using RMagick?!
  end

  def create
  	  user = User.find_by(email: params[:email].downcase)
	  if user && user.authenticate(params[:password])
      if user.activated?
  	    sign_in user
  	    redirect_back_or user
      else
        flash[:failure] = "Account not activated. Please check your email (i.e. #{user.email}) and hit the Activate link."
        redirect_to root_url
      end
	  else
	    # Create an error message and re-render the signin form.
	    flash.now[:error] = 'Invalid email/password combination!' # Not quite right!
      render 'new'
	  end
  end

  def destroy
  	sign_out
  	redirect_to root_url
  end

end
