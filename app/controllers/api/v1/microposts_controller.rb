module Api
 	module V1
 		class MicropostsController < ApplicationController
			include ApiVersion
			# 
			# NOTE: not necessary to handle  ActiveRecord::RecordNotFound
			# 		as production will redirect to a 404 page.
			def index
 				respond_with @microposts
 			end

			def show
				respond_with @micropost
			end
		end
	end
end
