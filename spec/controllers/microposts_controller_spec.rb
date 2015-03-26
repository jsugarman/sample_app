require 'spec_helper'

describe MicropostsController do

	let(:user) { FactoryGirl.create(:user) }
	let(:wrong_user) { FactoryGirl.create(:user) }

	# TODO: reacts to controller tests
	# describe "reacts to" do
	# 	before {
	# 		sign_in @user, no_capybara: false
	# 	} 
	# 	it { expect(controller).to receive(:create) }
	# 	it { expect(controller).to receive(:destroy) } 
	# end

	describe "POST create " do
		context "as wrong user" do
			# 
			# dubious values as this will create a micropost but for the currently signed in user
			# passing of the user_id is filtered out at the controller level
			# 
			before {
				sign_in wrong_user, no_capybara: true
 			}
			it "not to increment micropost count" do
				expect{ 
					post :create, micropost: { user_id: user.id, content: 'this is a wring use entry'} 
				}.not_to change(user.microposts,:count)
			end
		end

 		context "correct user" do
			before do
				# NOTES: 
				# - do not use capybara for unit test - instead call action directly
				# - could use factory to create microposts but this will immediatley increment the db count 
				#   and subsequent post :create will create a second micropost
				# - if you do use let or a local var to create a micropost then to use it without capybara
				#   then you will need to pass micropost objects attrbutes, i.e. micropost.attributes 
				#   as only the content attribute of a micropost object is permitted (and object is required)
				# 
				sign_in user, no_capybara: true
				post :create, micropost: { content: 'whatever you say dude' } 
			end
			it  "increments micropost count" do
 				expect(user.microposts.count).to eq(1)
	 		end
	 		it "redirects to root" do
	        	# post :create,  micropost: micropost.attributes # NOTE: also works for this 
	        	expect(response).to  redirect_to root_url 
	        end
		end
 	end # end of POST create block


	# TODO delete destroy tests for microposts controller
	describe "DELETE destroy" do
		# 
		# NOTE: capybara interferes with the delete action so must 
		# 		be switched off (don't know why?).
		# 

		# 
		# create a micropost ready for destroying, immediatley i.e. let!
		# 
		let!(:micropost) { FactoryGirl.create(:micropost, user: user) }

		context "as wrong user" do
			before do
				sign_in wrong_user, no_capybara: true
			end
			it "does NOT decrement micropost count" do
				expect{
					delete :destroy, id: micropost
				}.not_to change(user.microposts, :count)
 			end
			it "redirects to root_url" do 
				delete :destroy, id: micropost
				expect(response).to redirect_to root_url
			end
		end
		context "as correct user" do
	 		before do
				sign_in user, no_capybara: true
			end
			it "decrements micropost count" do
				expect{
					delete :destroy, id: micropost.id
				}.to change(user.microposts, :count).by(-1) 
			end
			it "redirects to root_url" do 
				delete :destroy, id: micropost
				expect(response).to redirect_to root_url
			end
		end
	end # end of DELETE destroy block

end
