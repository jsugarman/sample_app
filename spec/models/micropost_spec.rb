require 'spec_helper'

describe Micropost do
  
	# pending "add some examples to (or delete) #{__FILE__}"

	let (:user) { FactoryGirl.create(:user) }

	it "has a valid factory" do
  		expect(FactoryGirl.build(:micropost, user: user)).to be_valid
  	end
	
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
		describe '#user' do
		  subject { super().user }
		  it { is_expected.to eq(user)}
		end
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


end
