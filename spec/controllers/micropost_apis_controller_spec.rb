require 'spec_helper'
 RSpec.describe Api::V1::MicropostsController, type: :controller do
	let(:user) { FactoryGirl.create(:user) }

	describe "GET #show" do
		let(:micropost) { FactoryGirl.create(:micropost, user: user) }
 		context "when NOT signed in" do
		 	specify { 
			 	get :show, id: micropost.id, format: :json
				expect(response).to redirect_to signin_url
			}
		end
		context "when signed in" do
 			before do
				sign_in user, no_capybara: true
				get :show, id: micropost.id, format: :json
			end
			it { expect(response).to have_http_status(:success) }
			it "should render JSON formatted data" do
			 expect(response.body).to eq micropost.to_json
			end
			it "assigns instance variable @micropost" do
				expect(assigns(:micropost)).to eq micropost
			end
		end
	end
	describe "GET #index" do
		context "when NOT signed in" do
 		specify {
			 	get :index, format: :json
				expect(response).to redirect_to signin_url
			}
		end
		context "when signed in" do
			let(:microposts) { Micropost.all }
 			before do
				sign_in user, no_capybara: true
				get :index, format: :json
			end
			it { expect(response).to have_http_status(:success) }
			it "should render JSON formatted data" do
			 expect(response.body).to eq microposts.to_json
			end
			it "assigns instance variable @microposts" do
				puts microposts
				expect(assigns(:microposts)).to eq microposts
			end
			
		end
	end


end
