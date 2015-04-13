class MicropostApisController < ApplicationController

	before_filter :signed_in_user, only: [:index, :show] 
	# before_filter :micropost_exists, only: [:show]
	# def index; end;
	# def show

	# 	# render 'micropost_apis/show'
	# end

	def show
		@micropost = Micropost.find(params[:id])		
	rescue ActiveRecord::RecordNotFound
		flash[:failure] = "No Records Found!"
	end

	def index
		@microposts = Micropost.all
		respond_to do |format|
			format.html
			format.json { render json: @microposts }
		end
	end

private

	def micropost_api_params
		params.require(:micropost).permit(:id)
	end

	# def micropost_exists
	# 	@micropost = Micropost.find(params[:id])		
	# rescue ActiveRecord::RecordNotFound
	# 	flash[:failure] = "No Records Found!"
	# end

end
