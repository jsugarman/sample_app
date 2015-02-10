require 'spec_helper'

describe Micropost do
  
	# pending "add some examples to (or delete) #{__FILE__}"

	let (:user) { FactoryGirl.create(:user) }
	before do

		# @micropost = Micropost.new(content: "lorem ipsum", user_id: user.id)
		@micropost = user.microposts.build(content: "lorem ipsum")
	end

	subject { @micropost }

	# it { should respond_to (:content) }
	# it { should respond_to (:user_id) }

	it { expect(subject).to respond_to(:content) }
	it { expect(subject).to respond_to(:user_id) }


	it { expect(subject).to be_valid }

	describe "when user_id is NOT present" do
		before { @micropost.user_id = nil }
		it { expect(subject).not_to be_valid }
	end

	describe "accessible attributes" do
	
		it "should prevent access to user_id" do
			expect (Microposts.new(user_id: user.id)).to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end

	end


end
