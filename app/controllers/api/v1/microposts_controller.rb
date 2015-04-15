module Api
 	module V1
 		class MicropostsController < ApplicationController
			include ApiVersion
			
			# 
			# NOTE: not necessary to handle  ActiveRecord::RecordNotFound
			# 		as production will redirect to a 404 page.

			# GET /api/v1/microposts
			def index
 				respond_with @microposts
 			end

			# GET /api/v1/microposts/:id
			def show
				respond_with @micropost
			end

			# POST /api/v1/microposts.json
			def create
				@micropost = current_user.microposts.build(micropost_api_params)
				if @micropost.save
					render  json: @micropost, status: :created #201
				else
					render json: { errors: @micropost.errors.full_messages}, status: :unprocessable_entity #422
				end
			end

			# PATCH /ap1/v1/microposts/:id.json
			def update
 				if @micropost.update(micropost_api_params)
					render  json: 'true', status: :ok #200
				else
					render json: { errors: @micropost.errors.full_messages}, status: :unprocessable_entity #422
				end
			end

			# DELETE /api/v1/microposts/:id.json
			def destroy
				respond_with Micropost.destroy(params[:id])
			end

		private

			def micropost_api_params
				#specify required params and those permitted, all others restricted to prevent csrf
				# micropost_json = JSON.parse
				params.require(:micropost).permit(:user_id, :content)
			end	

			# def correct_user
			# 	@user = User.find(params[:user_id])
			# 	render json: { name: @user.name, email: @user.email }, status: :unauthorized unless current_user?(@user)
			# end

		end
	end
end
