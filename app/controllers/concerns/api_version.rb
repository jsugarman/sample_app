module ApiVersion extend ActiveSupport::Concern

	included do
		respond_to :json
		before_filter :set_micropost, only: [:show]
		before_filter :set_microposts, only: [:index]
		before_filter :signed_in_user, only: [:index, :show] 		
	end

private
	def set_micropost
		@micropost = Micropost.find(params[:id])
	end

 	def set_microposts
		@microposts = Micropost.all
	end


	
end
