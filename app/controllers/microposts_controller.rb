class MicropostsController < ApplicationController


before_filter :signed_in_user , only: [:create, :destroy]
before_filter :correct_user, only: :destroy
# before_action :signed_in_user, only: [:create, :destroy]

def create
	@micropost = current_user.microposts.build(micropost_params)
	if @micropost.save
		flash[:success] = "Micropost Created!"
		redirect_to root_url
	else
		@feed_items = []
		render 'static_pages/home'
	end
	
end

def destroy
	@micropost.destroy
	flash[:success] = "Micropost Deleted!"
	redirect_to root_url
end

# ------------------------------
private

def micropost_params
	#specify required params and those permitted, all others restricted to prevent csrf
	params.require(:micropost).permit(:content)
	# params.require(:user).permit(:name, :email, :password, :password_confirmation)
end	

# NOTE: overrides user_controller.rb correct_user method
def correct_user
	@micropost = current_user.microposts.find_by_id(params[:id])
	redirect_to root_url if @micropost.nil?
end


end
