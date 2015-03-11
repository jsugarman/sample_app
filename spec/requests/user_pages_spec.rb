require 'spec_helper'

describe 'User Pages' do

  subject { page }

# -----------------------------
describe 'Index Page' do

  let(:user) { FactoryGirl.create(:user) }
  before(:each) do
    sign_in user
    visit users_path
  end

  describe 'page' do
    it { should have_title('All Users') }
    it { should have_content('All Users') }
  end

  describe 'pagination' do

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }

    it { should have_selector('div.pagination') }

    it 'should list each user' do
      User.paginate(page: 1).each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end

  end

  describe 'delete links' do
    it { should_not have_link('delete') }
    describe 'as an admin user' do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit users_path
      end
      it { should have_link('delete', href: user_path(User.first)) }
      it 'should be able to delete another user' do
        expect do
          click_link('delete', match: :first)
        end.to change(User, :count).by(-1)
      end
      it 'should not be able to delete itself' do
        should_not have_link('delete', href: user_path(admin))
      end    
    end
  end
end

# -----------------------------
describe 'Profile Page' do 

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let!(:m1)   { FactoryGirl.create(:micropost, user: user, content: 'foo') }
  let!(:m2)   { FactoryGirl.create(:micropost, user: user, content: 'bar') }

  before do 
    sign_in user
    visit user_path(user)
  end

  describe 'page' do
    before do 
      visit user_path(user)
    end
    it { expect(page).to have_content(user.name) }
    it { expect(page).to have_title(full_title(user.name)) }
    it { expect(page).to have_selector('h1',   text: user.name) }
  end
  describe 'microposts' do
    before do 
      visit user_path(user)
    end
    it { expect(page).to have_content(m1.content) }
    it { expect(page).to have_content(m2.content) }
    it { expect(page).to have_content(user.microposts.count) }
  end
  describe "relationships" do 
    before do
      other_user.follow!(user)
      sign_in user
      visit user_path(user)
    end     
    it { expect(page).to have_link("1 followers", href: followers_user_path(user)) }
    it { expect(page).to have_link("0 following", href: following_user_path(user)) }
  end
  describe "follow button clicking" do
      before do
        sign_in user
        visit user_path(other_user)
      end
      it "should increment users list of followed users" do
        expect{ click_button "Follow" }.to change(user.followed_users, :count).by(1) 
      end
      it "should increment other user\'s list of followers" do
        expect{ click_button "Follow" }.to change(other_user.followers, :count).by(1) 
      end
      describe "should toggle the button" do
        before { click_button "Follow" }
        it { expect(page).to have_button('Unfollow') }
       end 
  end
  describe "unfollow button clicking" do
      before do
        user.follow!(other_user)
        sign_in user
        visit user_path(other_user)
      end
      it "should decrement users list of followed users" do
        expect{ click_button "Unfollow" }.to change(user.followed_users, :count).by(-1) 
      end
      it "should decrement other user\'s list of followers" do
        expect{ click_button "Unfollow" }.to change(other_user.followers, :count).by(-1) 
      end
      describe "should toggle the button" do
        before { click_button "Unfollow" }
        it { expect(page).to have_button('Follow') }
       end 
  end
end

# -----------------------------
describe 'Signup Page' do

  before { visit signup_path }

  describe 'page' do
    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  let(:submit) { 'Create my account' }

  it "should render a captcha" do
    pending "to be implemented  using RMagick?!"
  end


  describe 'with invalid information' do
    it 'should not create a user' do
      expect { click_button submit }.not_to change(User, :count)
    end

    describe 'after submission' do
     before { click_button submit }
     
     it { should have_title('Sign up') }
     it { should have_content('error') }
     it { should have_error_message('error')}
   end
  end

  describe 'with valid information' do
    before do
      ActionMailer::Base.deliveries.clear
      valid_signup 
    end

    it 'should create a user' do
      expect { click_button submit }.to change(User, :count).by(1)
    end

    it "should send an email" do
      expect{ click_button submit }.to change{ActionMailer::Base.deliveries.count}.by(1)
    end

    describe 'after submission' do
       before { click_button submit }
       let(:user) { User.find_by(email: 'user@example.com') }
       it { expect(page).to have_content("(i.e. #{ user.email })") }
       it { expect(page).to have_info_message('activate') }
    end
  end

end # end of signup block
# -----------------------------
describe 'Edit Page' do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in(user)
    visit edit_user_path(user)
  end

  describe 'page' do
    it { should have_content('Update your profile') }
    it { should have_title('Edit user') }
    it { should have_link('change', href: 'http://gravatar.com/emails') }
  end

  describe 'with invalid information' do
    before { click_button 'Save changes' }
    it { should have_error_message('error')}
  end

  describe 'with valid information' do
    let(:new_name)  { 'New Name' }
    let(:new_email) { 'new@example.com' }
    before do
      fill_in 'Name',             with: new_name
      fill_in 'Email',            with: new_email
      fill_in 'Password',         with: user.password
      fill_in 'Confirm Password', with: user.password
      click_button 'Save changes'
    end

    it { should have_title(new_name) }
    it { should have_selector('div.alert.alert-success') }
    it { should have_link('Sign out', href: signout_path) }
    specify { expect(user.reload.name).to  eq new_name }
    specify { expect(user.reload.email).to eq new_email }
  end

  describe 'forbidden attributes' do
    let(:params) do
      { user: { admin: true, password: user.password,
        password_confirmation: user.password } }
      end

      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end

      specify { expect(user.reload).not_to be_admin }
    end

  end
  # -----------------------------
  describe "Following/Followers Pages" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before{ user.follow!(other_user) }

    describe "following users" do
      before do
         sign_in user
         visit following_user_path(user)
      end
      it { expect(page).to have_title(full_title("Following")) }
      it { expect(page).to have_selector('h3', text: "Following") }
      it { expect(page).to have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
        before do
         sign_in other_user
         visit followers_user_path(other_user)
      end
      it { expect(page).to have_title(full_title("Followers")) }
      it { expect(page).to have_selector('h3', text: "Followers") }
      it { expect(page).to have_link(user.name, href: user_path(user)) }
    end

  end

end		