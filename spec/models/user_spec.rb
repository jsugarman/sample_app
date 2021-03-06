require 'spec_helper'

describe User do

  it "has a valid factory" do
  	expect(FactoryGirl.build(:user)).to be_valid
  end

  before do
   @user = User.new(name: "Example User", email: "user@example.com",
  					password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:authenticate) }
  it { is_expected.to respond_to(:remember_token) } 
  it { is_expected.to respond_to(:remember_digest) }
  it { is_expected.to respond_to(:admin) }
  it { is_expected.to respond_to(:microposts) }
  it { is_expected.to respond_to(:feed) }
  it { is_expected.to respond_to(:relationships) }
  it { is_expected.to respond_to(:followed_users) }
  it { is_expected.to respond_to(:reverse_relationships) }
  it { is_expected.to respond_to(:followers) }
  it { is_expected.to respond_to(:follow!) } 
  it { is_expected.to respond_to(:following?) } 
  it { is_expected.to respond_to(:unfollow!) } 
  it { is_expected.to respond_to(:activation_digest) } 
  it { is_expected.to respond_to(:activation_token) } 
  it { is_expected.to respond_to(:activated_at) } 
  it { is_expected.to be_valid }
  it { is_expected.not_to be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { is_expected.to be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email is mixed case" do
  	let(:mixed_case_email) { "foO@bAR.Com" }

  	it "should be saved as lower case" do
  		@user.email = mixed_case_email
  		@user.save
  		expect(@user.reload.email).to eq mixed_case_email.downcase 
  	end

  end

  describe "when name is too long" do
    before { @user.name = "a" * 65 }
    it { is_expected.not_to be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    specify { is_expected.not_to be_valid }
  end

  describe "when password is not present" do
	before do
	@user = User.new(name: "Example User", email: "user@example.com",
	                 password: " ", password_confirmation: " ")
	end
	specify { is_expected.not_to be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    specify { is_expected.not_to be_valid }
  end

  describe "when password is too short" do
  	before {@user.password = @user.password_confirmation = "a" * 5}
  	specify { is_expected.to be_invalid }
  end

  describe "return value of authenticate method" do
	  before { @user.save }
	  let(:found_user) { User.find_by(email: @user.email) }

	  describe "with valid password" do
	    specify { is_expected.to eq found_user.authenticate(@user.password) }
	  end

	  describe "with invalid password" do
	    let(:user_for_invalid_password) { found_user.authenticate("invalid") }

	    specify { is_expected.not_to eq user_for_invalid_password }
	    specify { expect(user_for_invalid_password).to be_falsey }
	  end

  end

  describe "when saving" do
    before { @user.save }

    describe '#remember_token' do
      subject { super().remember_token }
      it { is_expected.not_to be_blank }
    end

    describe '#remember_digest' do
      subject { super().remember_digest }
      it { is_expected.not_to be_blank }
    end
  end

  # -----------------------------------
  describe "micropost associations" do
    before { @user.save }
    
    let!(:newer_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }
    let!(:older_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }

    it "should have the right ordering of microposts" do
      expect(@user.microposts).to match_array([newer_micropost, older_micropost])
    end

    it "when delete user cascade microposts" do

      microposts = @user.microposts.dup
      @user.destroy
      # microposts.should_not be_empty

      microposts.each do |micropost|
        # expect(Micropost.find_by_id(micropost.id)).to be_empty
        expect(Micropost.find_by_id(micropost.id)).to be_nil
      end
    end

    describe "relationship associations" do
      # 
      # create some relationships
      # 
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        @user.save
        @user.follow!(other_user)
        other_user.follow!(@user)
      end

      it "when delete user cascade followed_user relationships" do
        # following
        active_relationships = @user.relationships.dup  
        @user.destroy

        active_relationships.each do |r|
          expect(Relationship.find_by_id(r)).to be_nil
        end
      end
  
      it "when delete user cascade follower relationships" do
          # follower
          passive_relationships = @user.reverse_relationships.dup  
          @user.destroy

          passive_relationships.each do |r|
            expect(Relationship.find_by_id(r)).to be_nil
          end
        end
    end

    describe "should include feeds" do
      context "from user" do
        let(:unfollowed_micropost) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
        it "should include older micropost" do
          expect(@user.feed).to include(older_micropost) 
        end
        it "should include newer micropost" do 
           expect(@user.feed).to include(newer_micropost)
        end
        it "should NOT include unfollowed micropost" do 
           expect(@user.feed).not_to include(unfollowed_micropost)
        end
        it "match the order latest to oldest" do 
           expect(@user.feed).to match_array([newer_micropost,older_micropost])
        end
      end
      context "from other users" do
        let(:followed_user) { FactoryGirl.create(:user) }
        before do
          @user.follow!(followed_user)
          3.times do |i|
            followed_user.microposts.create!(content: "lorem imspum - order #{i.to_s}")
          end
        end
        it "should include microposts from followed users" do 
          followed_user.microposts.each { |m| expect(@user.feed).to include(m) } 
        end
      end
    end # end of feed block 

  end # end of microposts associations block

  # -----------------------------------
  describe "Following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save!
      @user.follow!(other_user)
    end
    # should have a follow! method
    describe "should have a follow! method" do
      it "that incremements followed_users" do
        expect(@user.followed_users).to include(other_user)
      end
    end  
    # NOTE: this syntax will ignore pluraizaition of the function/method - yuk!
    # it { should be_following(other_user) }
    describe "should have a following? method" do
      it "that returns boolean based on whether specified user is followed or not" do
        expect(@user.following?(other_user)).to be_valid
      end
    end
    describe "should cascade delete relationships when user deleted" do
      let(:user_id) { @user.id }
      before do
        @user.destroy 
      end
      it { expect(Relationship.where('follower_id = ?',user_id)).to be_empty }
    end
    describe "should have unfollowing! method" do
      before { @user.unfollow!(other_user) }
      it "that removes specified followed user" do
        expect(@user.followed_users).not_to include(other_user)
      end
    end
    describe "followed user" do
      it "should include follower" do
        expect(other_user.followers).to include(@user) 
      end
    end

  end # end of Following block

  # -----------------------------------
  describe "Activation" do
    before do
      @user.activation_token = User.new_token
      @user.activation_digest = User.digest(@user.activation_token)
      @user.save!
    end
    it "should not authenticate nil token" do
      expect(@user.authenticated?(:activation, '')).to be false
    end    
    it "should not authenticate random token" do
      expect(@user.authenticated?(:activation, User.new_token)).to be false
    end    
    it "should authenticate valid token" do
      expect(@user.authenticated?(:activation, @user.activation_token)).to be true
    end    
  end # end of Activation block
  # -----------------------------------
  
end