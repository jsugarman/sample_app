require 'spec_helper'

describe "Micropost Pages" do

subject { page }


let(:user) { FactoryGirl.create(:user) }
before { sign_in user }

#---------------------------------- 
 describe "micropost creation" do
 	before { visit root_path}

 	context "with invalid information" do
 		it "should not create a micropost" do
 			expect {click_button "Post" }.not_to change(Micropost, :count)
 		end
 		
 		context "should raise error messages" do
 			before { click_button "Post" }	
 			it { expect(page).to have_content('error') }
 		end
 	end

 	context "with valid information" do
 		# pending "valid mp creationchecks"
 		before { fill_in 'micropost_content', with: "lorem ipsum" }

 		it "should create a micropost" do
 			expect { click_button "Post" }.to change(Micropost, :count).by(1)
 		end
 	end

 end

  #----------------------------------
  describe "micropost destruction" do
  	before { FactoryGirl.create(:micropost, user: user) }

  	context "as correct user" do
  		before { visit root_path }

  		it "should delete a micropost" do
  			expect { click_link "delete" }.to change(Micropost, :count).by(-1)
  		end
		
		it "should flash successful deletion" do
			expect { click_link "delete" }.to change(Micropost, :count).by(-1)
			expect(page).to have_selector('div.alert.alert-success')
		end
		
	end
  end
  #----------------------------------

end
