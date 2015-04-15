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

			def create
				respond_with Micropost.create(params[:micropost])
			end

			def update
				respond_with Micropost.update(params[:id],params[:micropost])
			end

			def destroy
				respond_with Micropost.destroy(params[:id])
			end
		end
	end
end
