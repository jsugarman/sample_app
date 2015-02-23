require 'spec_helper'

describe User do


  it "has a valid factory" do
  	FactoryGirl.build(:user).should be_valid
  end

  before do
   @user = User.new(name: "Example User", email: "user@example.com",
  					password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin }


  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
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
    it { should_not be_valid }
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

    it { should_not be_valid }
  end

  describe "when password is not present" do
	before do
	@user = User.new(name: "Example User", email: "user@example.com",
	                 password: " ", password_confirmation: " ")
	end
	it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
  	before {@user.password = @user.password_confirmation = "a" * 5}
  	it { should be_invalid }
  end

  describe "return value of authenticate method" do
	  before { @user.save }
	  let(:found_user) { User.find_by(email: @user.email) }

	  describe "with valid password" do
	    it { should eq found_user.authenticate(@user.password) }
	  end

	  describe "with invalid password" do
	    let(:user_for_invalid_password) { found_user.authenticate("invalid") }

	    it { should_not eq user_for_invalid_password }
	    specify { expect(user_for_invalid_password).to be_false }
	  end

  end

  describe "when saving" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end


  describe "micropost associations" do
    before { @user.save }
    
    let!(:newer_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }
    let!(:older_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }

    it "should have the right ordering of microposts" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "when delete user cascade microposts" do

      microposts = @user.microposts.dup
      @user.destroy
      # microposts.should_not be_empty

      microposts.each do |micropost|
        # expect(Micropost.find_by_id(micropost.id)).to be_nil
        Micropost.find_by_id(micropost.id).should be_nil

      end
    end


    describe "status" do
      let(:unfollowed_micropost) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
     
     #  it "should include newer micropost" do
     #   expect(:feed).to include?(newer_micropost) 
     # end
     #  it "should include older micropost" do
     #   expect(:feed).to include?(older_micropost) 
     #  end
     #  it "should include older micropost" do 
     #    expect(:feed).to include(unfollowed_micropost)
     #  end
      # 
      # from tutorial
      # 
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_micropost) }
    end

  end 

end