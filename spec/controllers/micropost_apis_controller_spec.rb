require 'spec_helper'

RSpec.describe MicropostApisController, type: :controller do

	let(:user) { FactoryGirl.create(:user) }

	describe "GET #show" do
		let(:micropost) { FactoryGirl.create(:micropost, user: user) }
 		context "when NOT signed in" do
		 	specify { 
			 	get :show, id: micropost.id
				expect(response).to redirect_to signin_url
			}
		end
		context "when signed in" do
 			before do
				sign_in user, no_capybara: true
				get :show, {id: micropost.id} 
			end
			it do
			 expect(response).to render_template 'micropost_apis/show'
			end
			it "assigns instance variable @micropost" do
				expect(assigns(:micropost)).to eq micropost
			end
		end
	end
	describe "GET #index" do
		context "when NOT signed in" do
 		specify {
			 	get :index
				expect(response).to redirect_to signin_url
			}
		end
		context "when signed in" do
			let(:microposts) { Micropost.all }
 			before do
				sign_in user, no_capybara: true
				get :index
			end
			it do
			 expect(response).to render_template 'micropost_apis/index'
			end
			it "assigns instance variable @microposts" do
				expect(assigns(:microposts)).to eq microposts
			end
			it "responds to JSON format" do
				skip "todo"
			end
		end
	end


end
