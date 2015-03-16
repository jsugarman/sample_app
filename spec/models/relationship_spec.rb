require 'spec_helper'

describe Relationship do
  # pending "add some examples to (or delete) #{__FILE__}"

  #@TODO
   # it "has a valid factory" do
  # 	FactoryGirl.build(:relationship).should be_valid
  # end
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

	it { expect(relationship).to be_valid }
	it { expect(subject).to respond_to(:follower) }
	it { expect(subject).to respond_to(:followed) }

	# 
	# NOTE: its method is depreacted
	# 
	# it { expect(:follower).to eq(relationship.follower) } 

	describe '#follower' do
	  subject { super().follower }
	  it { is_expected.to eq(follower) }
	end

	describe '#followed' do
	  subject { super().followed }
	  it { is_expected.to eq(followed) }
	end
	
	it "should prevent access to follower id" do
		skip "should, infact, prevent follower_id being changed via controller"
		expect do
			Relationship.new(follower_id: follower.id)
		end.to raise_error(-20000, "whatever error")		
		# (ActiveModel::MassAssignmentSecurity::Error)
	end

	context "should prevent follower_id value being nil" do
		before { relationship.follower_id = nil }
		it { expect(relationship).not_to be_valid }
	end

	context "should prevent followed_id value being nil" do
		before { relationship.followed_id = nil }
		it { expect(relationship).not_to be_valid }
	end
	
end
