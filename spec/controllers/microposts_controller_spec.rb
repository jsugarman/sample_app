require 'spec_helper'

describe MicropostsController do

	# let!(:user)	     		{ FactoryGirl.create(:user) }
	# let(:micropost)  		{ FactoryGirl.create(:micropost, user: user) }
	# let(:other_user) 		{ FactoryGirl.create(:user) }
	# let(:other_micropost)   { FactoryGirl.create(:micropost, user: other_user) }


	before do
		# puts "BEFORE post count is #{@user.microposts.count}"
		@user = FactoryGirl.create(:user) 
		# @wrong_user = FactoryGirl.create(:user) 
		# sign_in @user
	end

	# TODO: reacts to controller tests
	# describe "reacts to" do
	# 	before {
	# 		sign_in @user, no_capybara: false
	# 	} 
	# 	it { expect(controller).to receive(:create) }
	# 	it { expect(controller).to receive(:destroy) } 
	# end

	describe "POST create " do 		
		# 
		
		# context "as wrong user" do
		# 	before {
		# 		sign_in @wrong_user, no_capybara: false
		# 	}
		# 	it do
		# 		expect{ 
		# 			post :create, micropost: micropost 
		# 			# post :create, microposts_path, micropost: micropost
		# 		}.not_to change(@user.microposts,:count)
		# 	end
		# end

 		context "as correct user" do
 			let(:micropost) { FactoryGirl.create(:micropost, user: @user) } 
			before do
				# @micropost = FactoryGirl.create(:micropost, user: @user)
				sign_in @user, no_capybara: false
				post :create, id: micropost
			end
			it  "increments micropost count" do
				expect(Micropost.count).to eq(1)
	 		end
			it  "redirects to root_url" do				
				expect(response).to redirect_to root_url
	 		end
	 	end

	end # end of POST create block


	# TODO delete destroy tests for microposts controller
	# describe "DELETE destroy" do
	

	# 	# 
	# 	# NOTE: capybara interferes with the delete action so must 
	# 	# 		be switched off (don't know why?).
	# 	# 
	# 	context "as wrong user" do
	# 		skip "to be completed"
	# 		before do
	# 			@micropost = FactoryGirl.create(:micropost, user: @user)
	# 			sign_in @wrong_user, no_capybara: true
	# 		end
	# 		it "does NOT decrement micropost count" do
	# 			expect{
	# 				delete :destroy, id: @micropost
	# 			}.not_to change(Micropost, :count)
 # 			end
	# 		it "redirects to root_url" do 
	# 			delete :destroy, id: @micropost
	# 			expect(response).to redirect_to root_url
	# 		end
	# 	end
	# 	context "as correct user" do

	#  		before do
	# 			sign_in @user, no_capybara: true
	# 			@micropost = FactoryGirl.create(:micropost, user: @user)
	# 		end
	# 		it "decrements micropost count" do
	# 			expect{
	# 				delete :destroy, id: @micropost
	# 			}.to change(Micropost, :count).by(-1) 
	# 		end
	# 		it "redirects to root_url" do 
	# 			delete :destroy, id: @micropost
	# 			expect(response).to redirect_to root_url
	# 		end
	# 	end
	# end # end of DELETE destroy block

end
