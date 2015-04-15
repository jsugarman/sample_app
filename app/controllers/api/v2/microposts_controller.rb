module Api
 	module V2
 		class MicropostsController < ApplicationController
			include ApiVersion	
			# 
			# NOTE: not necessary to handle  ActiveRecord::RecordNotFound
			# 		as production will redirect to a 404 page.
			def index
 				respond_with @microposts, only: [:user_id,:content,:created_at] 
 			end

			def show
				respond_with @micropost, only: [:id, :user_id,:content,:created_at] 
			end
		end
	end
end
