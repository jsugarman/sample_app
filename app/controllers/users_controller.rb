class UsersController < ApplicationController

	before_action :unsigned_in_user, only: [:new, :create]
	before_action :signed_in_user, only: [:index, :edit, :update, :destroy] 
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: [ :destroy ]


	  def index
	  	@users = User.paginate(page: params[:page])
	  end

	  def show
	  	@user = User.find(params[:id])
	  	@microposts = @user.microposts.paginate(page: params[:page])
	  end

	  def new
	  	@user = User.new
	  end

	  def edit
	  end

	  def update
	    if @user.update_attributes(user_params)
	      flash[:success] = "Profile updated"
		  redirect_to @user
	    else
	      render 'edit'
	    end
	  end

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

	  def destroy
	  	user_to_delete = User.find(params[:id])

		if current_user?(user_to_delete)
			flash[:failure] = "You cannot delete yourself, even if you are admin!"	
		else
		    user_to_delete.destroy
			flash[:success] = "User deleted."		
		end
	   
	    redirect_to users_path
  	  end

# -----------------------
private
# -----------------------

	def user_params
		#specify required params and those permitted, all others restricted to prevent csrf
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end	

	def unsigned_in_user
		redirect_to(root_url, notice: "You are already signed in!") if signed_in?
	end

  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_url) unless current_user?(@user)
  	end

  	def admin_user
  		redirect_to(root_url) unless current_user.admin?
  	end

end
