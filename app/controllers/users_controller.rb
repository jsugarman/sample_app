class UsersController < ApplicationController
 
 # -----------------------
	  def show
	  	@user = User.find(params[:id])
	  end
# -----------------------
	  def new
	  	@user = User.new
	  end
# -----------------------
	  def edit
		@user = User.find(params[:id])
	  end
# -----------------------
	  def update
	    @user = User.find(params[:id])
	    if @user.update_attributes(user_params)
	      # Handle a successful update
	      # @user.save
	      flash[:success] = "Profile updated"
		  redirect_to @user

	      # flash[:success] = "Details Updated Succesfully!"
	      # redirect_to @user
	    else
	      render 'edit'
	    end
	  end
# -----------------------
	  def create
	    @user = User.new(user_params)    # Not the final implementation!
	    if @user.save
	    	sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
	    else
			render 'new'
	    end
	  end
# -----------------------
  private

# -----------------------
	  def user_params
	  		#specify required params and those permitted, all others restricted to prevent csrf
	  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end
# -----------------------
  
end
