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

    context "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the users\'s feed - i.e. list of microposts" do
          user.feed.each do |item|
            expect(page).to have_selector("li##{item.id}", text: item.content)
          end
      end
      

      
      describe "should render feed in descending order of creation date" do

        let!(:feed_user) { FactoryGirl.create(:user) }
        # before do          
          
          # feed_user.save
          let!(:newer_feed) { FactoryGirl.create(:micropost, user: feed_user, created_at: 1.hour.ago) }
          let!(:older_feed) { FactoryGirl.create(:micropost, user: feed_user, created_at: 1.day.ago) }
        # end

        it "should have the right ordering of microposts" do
          pending " not working fix"
          feed_user.microposts.should == [newer_feed,older_feed]
        end
      end

    end


  end

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