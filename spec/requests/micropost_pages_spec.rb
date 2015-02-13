require 'spec_helper'

describe "Micropost Pages" do

	subject { page }


	let(:user) { FactoryGirl.create(:user) }
	before { sign_in(user) }
#---------------------------------- 
 describe "micropost creation" do
 	before { visit root_path}

 	context "with invalid information" do

 		it "should not not create a micropost" do
 			expect {click_button "Post" }.not_to change(Micropost, :count)
 		end
 		
 	end

 	context "with valid information" do
 		pending "valid mp creationchecks"
 	end

 end

  #----------------------------------
end
