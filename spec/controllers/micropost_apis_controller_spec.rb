require 'spec_helper'
 RSpec.describe Api::V1::MicropostsController, type: :controller do

	let(:user) 		{ FactoryGirl.create(:user) }
	let(:micropost) { FactoryGirl.create(:micropost, user: user) }

	describe "GET #show" do
		# let(:micropost) { FactoryGirl.create(:micropost, user: user) }
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
 	describe "POST #create" do
 		context "when NOT signed in" do
			it "should redirect to signin_url" do
				post :create, format: :json, micropost: { user_id: user.id, content: "this should never have been created"} 
				expect(response).to redirect_to signin_url
			end
		end
		context "when signed in" do
			before do
				sign_in user, no_capybara: true
				post :create, format: :json, micropost: { user_id: user.id, content: "hey there form JSON" }
			end
			it "increments micropost count for user" do
				expect(user.microposts.count).to eq(1)
			end
			it it 'responds with status CREATED (201)' do
				expect(response.status).to eq 201
			end
			it 'responds with content type of json' do
	        	expect(response.content_type).to eq 'application/json'
	      	end

			context 'when invalid JSON in request' do
				before do
					patch :create, format: :json, id: micropost,  micropost: { user_id: nil, content: "hey there form JSON" }
				end
				it 'responds with status unprocessable entity (422)' do
					expect(response.status).to eq(422)
				end
			end
		end
	end
	describe "PATCH #update" do

		# let(:micropost) { FactoryGirl.create(:micropost, user: user) }
		before do
			micropost.content = "no more lorem ipsum"
		end
 		context "when NOT authenticated" do
			it "should redirect to signin_url" do
				# 
				# TODO: pass JSON explicitly??
				# 
				# patch :update, id: micropost, micropost: { content: micropost.content, user_id: micropost.user_id }
				patch :update, id: micropost, micropost: { content: micropost.content, user_id: micropost.user_id }
				expect(response).to redirect_to signin_url
			end
		end
		context "when authenticated" do
			before do			
				sign_in user, no_capybara: true
				patch :update, format: :json, id: micropost, micropost: { content: micropost.content, user_id: micropost.user_id }
			end
			it "changes micropost content" do
				expect(user.microposts.first.content).to eq ("no more lorem ipsum")
			end
			it "responds with JSON content type" do
				expect(response.content_type).to eq 'application/json'
			end
			it 'responds with status OK (200)' do
				expect(response.status).to eq 200
			end

			context 'when invalid JSON in request' do
				before do
					patch :update, format: :json, id: micropost, micropost: { content: micropost.content, user_id: nil }	
				end
				it 'responds with status unprocessable entity (422)' do
					expect(response.status).to eq(422)
				end
			end

		end
	end
	describe "DELETE #destroy" do
		
		context 'when NOT authenticated' do
			before { delete :destroy, format: :json, id: micropost.id }
			it { expect(response).to redirect_to signin_url }
		end
		context 'when authenticated' do
			before do
				sign_in user, no_capybara: true
				delete :destroy, format: :json, id: micropost.id
			end
			it "responds with JSON content type" do
				expect(response.content_type).to eq 'application/json'
			end
			it 'responds with no content status (204)' do
				expect(response.status).to eq(204)
			end
		end

	end


end
