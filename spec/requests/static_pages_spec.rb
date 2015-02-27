require 'spec_helper'

describe "Static Pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject {page}

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
  
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }
    it_should_behave_like "all static pages"    
    it { should_not have_title('Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        # puts "BEFORE each signed-in user example"
        # 
        # create sufficient microposts to require more than one page
        # 
        31.times { FactoryGirl.create(:micropost, user: user, content: Faker::Lorem.sentence(5)) }
        sign_in user
        visit root_path
      end
      after { user.microposts.destroy_all }

      describe "should update \"remaining characters\" using javascript" do
        before do 
          fill_in 'micropost_content', with: "13 characters" 
        end
        it "",js: true do
          expect(page).to have_selector('td.countdown', text: '127 characters remaining')
        end
      end
      it "should display a pluralized count of user microposts" do
        micropost_count = user.microposts.count
        expect(page).to have_selector('span', text:  "#{ micropost_count } micropost".pluralize(micropost_count))
      end
      it "should apply pagination" do
        expect(page).to have_selector('div.pagination')
      end
      it "should render the user's feed, 30 per page" do
        user.feed.paginate(page: 1, :per_page => 30).each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      describe "should render feed by descending date created" do
        pending("needs implementing")
        let!(:newest_feed) { FactoryGirl.create(:micropost, user: user, created_at: 1.minute.ago) }
        let!(:newer_feed) { FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago) }
        let!(:older_feed) { FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago) }
        
        xit "should render feed in descending order of creation date" do
          user.microposts.should == [newest_feed, newer_feed, older_feed]
        end  
      end
      describe "should prevent deletion of other user's posts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before { visit user_path(other_user) }
        it { expect(page).to_not have_link('delete') }
      end
      describe "each feed item" do
        it "should have a list item with unqiue id" do 
          user.feed.paginate(page: 1, :per_page => 30).each do |item|
              expect(page).to have_selector("li##{item.id}")
          end
        end
      end
      
    end #signed in end

  end #home page end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About Us' }
    it_should_behave_like "all static pages"
  end

  describe "Contacts page" do
    before {visit contacts_path}
    let(:heading)    { 'Contacts' }
    let(:page_title) { 'Contacts' }
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    
    click_link "Help"
    expect(page).to have_title(full_title('Help'))

    click_link "Contacts"
    expect(page).to have_title(full_title('Contacts'))

    click_link "Home"
    expect(page).to have_title(full_title(''))

    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

end