require 'spec_helper'

describe Micropost do
  
	# pending "add some examples to (or delete) #{__FILE__}"

	let (:user) { FactoryGirl.create(:user) }
	before do

		# @micropost = Micropost.new(content: "lorem ipsum", user_id: user.id)
		@micropost = user.microposts.build(content: "lorem ipsum")
	end

	subject { @micropost }

	# context "when valid requests" do
		it { expect(subject).to respond_to(:content) }
		it { expect(subject).to respond_to(:user_id) }
		it { expect(subject).to respond_to(:user) }	
		it { expect(subject).to be_valid }
	# end

	context "when micropost.user called" do
		its(:user) { should == user}
	end	

	context "when user_id is NOT present" do
		before { @micropost.user_id = nil }
		it { expect(subject).not_to be_valid }
	end

	context "when content is blank" do
		before { @micropost.content = " "}
		it { expect(subject).to_not be_valid}
	end

	context "when content is too long" do
		before{ @micropost.content = "a"*141 }
		specify { expect(subject).to_not be_valid}
	end

	context "when user_id updated" do
		# before { @micropost.user_id = 201 }
		specify "it should prevent changing of user_id" do
			pending "need test ensure controller cannot modify user_id attribute"
		 	expect(@micropost.user_id).to_not eq(201)
		end
	end


end
