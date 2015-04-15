module Api
 	module V1
 		class MicropostsController < ApplicationController
			include ApiVersion
			# 
			# NOTE: not necessary to handle  ActiveRecord::RecordNotFound
			# 		as production will redirect to a 404 page.
			def index
				@microposts = Micropost.all
 				respond_with @microposts
 			end

			def show
				# @micropost = Micropost.find(params[:id])
				respond_with @micropost
			end
		end
	end
end
