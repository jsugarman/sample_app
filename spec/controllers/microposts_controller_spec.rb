require 'spec_helper'

describe MicropostsController do

	let(:user) 	     		{ FactoryGirl.create(:user) }
	let(:micropost)  		{ FactoryGirl.create(:micropost, user: user) }
	# let(:other_user) 		{ FactoryGirl.create(:user) }
	# let(:other_micropost)   { FactoryGirl.create(:micropost, user: other_user) }
	
	describe  "POST create" do
		# before { sign_in user }
		# it "increments micropost count " do 
		# 	expect do
		# 		post :create, micropost: micropost
		# 	end.to change(user.microposts, :count).by(1) 
		# end
		# context "redirects to root" do 
		# 	pending "needs fixing - no route error"
		# 	# before { post :create, micropost: micropost }
		# 	# it  { expect(response).to redirect_to root_path }
		# end
	end

	describe "DELETE destroy" do
		pending "needs fixing - no route error"
		# before { sign_in user }
		# it "decrements micropost count" do
			
		# 	expect do
		# 		delete :destroy, micropost: micropost	
		# 	end.to change(user.microposts, :count).by(1)
		# end
	end
end
