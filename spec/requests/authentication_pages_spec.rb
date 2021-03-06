require 'spec_helper'

describe "Authentication Pages" do

  subject { page }

    describe "signin" do
    
      before { visit signin_path }

      it { expect(page).to have_content('Sign in') }
      it { expect(page).to have_title('Sign in') }
      it { expect(page).to have_link('Sign in',     href: signin_path) }

      it "should render a captcha" do
        skip "to be implemented  using RMagick?!"
      end

      describe "with invalid information" do
          before { click_button "Sign in" }

          it { expect(page).to have_title('Sign in') }
          it { expect(page).to have_message('error','Invalid') }

      	  describe "after visiting another page" do
      		  before { click_link "Home" }
            it { expect(page).to_not have_message('error','Invalid') }
      	  end
      end

      describe "with unactivated account information" do
        let(:unactivated_user) { FactoryGirl.create(:user, activated: false, activated_at: '') }
        before { sign_in unactivated_user }
        it { expect(page).to have_content('Sign in') }
        it { expect(page).to have_content('Account not activated') }
        it { expect(page).to have_message('failure','not activated') }
        it { expect(page).to have_link('Sign in', href: signin_path) }
      end

      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in(user) }
        it { expect(page).to have_title(user.name) }
        it { expect(page).to have_link('Users',       href: users_path) }
        it { expect(page).to have_link('Profile',     href: user_path(user)) }
        it { expect(page).to have_link('Settings',    href: edit_user_path(user)) }
        it { expect(page).to have_link('Sign out',    href: signout_path) }
        it { expect(page).to_not have_link('Sign in', href: signin_path) }  
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { expect(page).to have_link('Sign in') }
        end
      end

      describe "after sign in" do
          let(:user) { FactoryGirl.create(:user) }
          before { sign_in user, no_capybara: true }
          describe "sign up" do
            before {  get signup_path }
            specify { expect(response).to redirect_to_root } 
          end
          describe "post on users" do
            before {  post users_path }
            specify { expect(response).to redirect_to_root } 
          end
      end
    end

    describe "authorization" do

      describe "for non-signed-in users" do

        let(:user) { FactoryGirl.create(:user) }

        it { expect(page).to_not have_title(user.name) }
        it { expect(page).to_not have_link('Users',       href: users_path) }
        it { expect(page).to_not have_link('Profile',     href: user_path(user)) }
        it { expect(page).to_not have_link('Settings',    href: edit_user_path(user)) }
        it { expect(page).to_not have_link('Sign out',    href: signout_path) }

        describe "when attempting to visit a protected page" do
            before do
              visit edit_user_path(user)
              valid_signin(user) 
            end
            describe "after signing in" do
              it "should render the desired protected page" do
                expect(page).to have_title('Edit user')
              end
            end
        end

        # 
        # do NOT mix capybara helpers (i.e. visit, page) with Rails-rspec helps
        # use get only in this case
        # 
        describe "in the Users controller" do

          describe "when visiting the show page" do
            before { get user_path(user) }
            specify { expect(response).to redirect_to_signin }
          end

          describe "when visiting the edit page" do
            before { get edit_user_path(user) }
            specify { expect(response).to redirect_to_signin }
          end
          describe "when submitting to the update action" do
            before { patch user_path(user) }
            specify { expect(response).to redirect_to_signin }
          end
          describe "when visiting the user index" do
            before { get users_path }
            specify { expect(response).to redirect_to_signin }
          end
          describe "when visiting the following page" do
            before { get following_user_path(user) }
            specify { expect(response).to redirect_to_signin }
          end  
          describe "when visiting the followers page" do
            before { get followers_user_path(user) }
            specify { expect(response).to redirect_to_signin }
          end
        end

        describe "in the Microposts controller" do
          describe "submitting to the create action" do
            before { post microposts_path }
            specify { expect(response).to redirect_to_signin }
          end
          describe "submitting to the destroy action" do
            before { delete micropost_path(FactoryGirl.create(:micropost)) }
            specify { expect(response).to redirect_to_signin }
          end
        end

        describe "in the Relationships controller" do
          describe "submitting to the create action" do
            before { post relationships_path }
            specify { expect(response).to redirect_to_signin }
          end
          describe "submitting to the destroy action" do
            before { delete relationship_path(1) }
            specify { expect(response).to redirect_to_signin }
          end
        end
        
      end
    end
  
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to_root }
      end
      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to_root }
      end
    end

    describe "as admin user" do
      let (:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin, no_capybara: true }
      describe "submitting a DELETE request to the users#destroy action for themselves" do
          specify { expect { delete user_path(admin) }.not_to change(User, :count) }
          before { delete user_path(admin) }
          specify { expect(response).to redirect_to(users_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin, no_capybara: true }
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to_root }
      end
    end

    describe "AccountActivationController" do
        
      let!(:unactivated_user) do
        token = User.new_token
        digest = User.digest(token)
        FactoryGirl.create(:user,
                          activated: false,
                          activated_at: '',
                          activation_token: token,
                          activation_digest: digest) 
      end
      
      # 
      # rspec-rails checks - for response redirects
      # 
      describe "GET the edit_account_activation path" do
        describe "with INVALID activation token"  do
          before { get edit_account_activation_path(id: User.new_token, email: unactivated_user.email) }
          it { expect(response).to redirect_to_root }
        end              
        describe "with VALID activation token" do
          before { get edit_account_activation_path(id: unactivated_user.activation_token, email: unactivated_user.email) }
          it { expect(response).to redirect_to(user_path(unactivated_user)) }
        end
        describe "with ALREADY activated activation token" do
          before do
           get edit_account_activation_path(id: unactivated_user.activation_token, email: unactivated_user.email)
           get edit_account_activation_path(id: unactivated_user.activation_token, email: unactivated_user.email)
          end
          it { expect(response).to redirect_to_root }              
        end
      end

      # 
      # capybara checks - for page messages/content
      # 
      describe "VISIT the edit_account_activation path (capybara)" do                
        describe "with INVALID activation token" do
          before { visit edit_account_activation_path(id: User.new_token, email: unactivated_user.email) }
          it { expect(page).to have_message('danger', 'invalid token') }  
        end
        describe "with VALID activation token" do
          before { visit edit_account_activation_path(id: unactivated_user.activation_token, email: unactivated_user.email) }
          it { expect(page).to have_message('success', 'Account activated!') }
        end
        describe "with ALREADY activated activation token" do
          before do 
            visit edit_account_activation_path(id: unactivated_user.activation_token, email: unactivated_user.email) 
            visit edit_account_activation_path(id: unactivated_user.activation_token, email: unactivated_user.email) 
          end
          it { expect(page).to have_message('danger', 'already activated!') }              
        end
      end
    end # end of Activation block


    describe PasswordResetsController do

      let(:user) { FactoryGirl.create(:user) }

      before { ActionMailer::Base.deliveries.clear }

       describe "new_password_reset controller" do
          describe "GET new" do
            before { get new_password_reset_path }
            it "renders new template " do          
              expect(response).to render_template(:new)
            end
          end
          describe "POST with invalid email" do
            before { post password_resets_path, password_resets: { email: 'whatever@where.com' } }
            it "does NOT incremement mail deliveries" do
              expect(ActionMailer::Base.deliveries.count).to eq(0)
            end
            it "renders new template again" do
              expect(response).to render_template(:new)
            end
          end
          describe "POST with valid email address" do
            before { post password_resets_path, password_resets: { email:  user.email } }
            it "increments mail deliveries by 1 " do
              expect(ActionMailer::Base.deliveries.count).to eq(1)
            end
            it "redirects to root" do
              expect(response).to  redirect_to_root
            end
          end
      end
      
      describe "edit_password_reset controller" do
        it "with invalid reset token" do
          get edit_password_reset_path('invalid token', {email: user.email}) 
          expect(response).to redirect_to_root
        end
        describe "with valid reset token and... " do
          before do
            # 
            # use model to create reset digest
            # 
            user.create_reset_digest
          end
          it "valid email, activated user should render edit template" do
            get edit_password_reset_path(user.reset_token, {email: user.email})
            expect(response).to render_template('edit')
          end
          it "invalid mail should redirecto to root" do
            get edit_password_reset_path(user.reset_token, {email: 'invalid email'})
            expect(response).to redirect_to_root
          end
          it "valid email but unactivated user should redirect to root" do
            user.toggle!(:activated)
            get edit_password_reset_path(user.reset_token, {email: user.email})
            expect(response).to redirect_to_root
          end
        end
      end

      describe "password_reset controller" do
        before do
          user.create_reset_digest
        end
        it "valid email and password should redirect to user\'s page" do 
          patch password_reset_path(user.reset_token),
          { email: user.email, 
                    user: { 
                        password: "foobar", 
                        password_confirmation: "foobar" 
                    }
           }
           expect(response).to redirect_to(user)
        end
        it "invalid email, valid password should redirect to root" do 
          patch password_reset_path(user.reset_token),
          { email: 'invalid email', user: { password: "foobar", password_confirmation: "foobar" }
           }
           expect(response).to redirect_to_root
        end
        it "valid email, invalid password should remain on page" do 
          patch password_reset_path(user.reset_token),
          { email: user.email, user: { password: "different", password_confirmation: "passwords" }
           }
           expect(response).to render_template 'edit'
        end
        it "valid email, blank password should remain on page" do 
          patch password_reset_path(user.reset_token),
          { email: user.email, user: { password: " ", password_confirmation: "irrelevant" }
           }
           expect(response).to render_template 'edit'
        end
      end

      # 
      #  capybara
      # 
      describe "when forgotten password clicked" do
        before do 
          visit signin_path 
          click_link "forgotten password"
        end
        it { expect(page).to have_title("Forgotten Password") }
        describe "when invalid email submitted" do
          before do
           fill_in 'Email', with: 'whatever@hole.com.uk'
           click_button 'Submit reset request'
          end
          it { expect(page).to have_title("Forgotten Password")  }
          it { expect(page).to have_message('danger','not found') }
        end
        describe "when valid email submitted" do
          before do
           fill_in 'Email', with: user.email
           click_button 'Submit reset request'
          end
          it { expect(page).to have_title(full_title(''))  }
          it { expect(page).to have_link('Sign up now')  }
          it { expect(page).to have_message('info',"confirmation sent to #{user.email}") }
        end
      end
      
      describe "when reseting the password" do
        before do
          user.create_reset_digest
        end

        describe "using invalid email" do
          before do
              visit edit_password_reset_path(user.reset_token, {
              email: 'invalid email'} )
          end
          it { expect(page).to have_title('Sample App') }
          it { expect(page).to have_message('error','invalid') }
          it { expect(page).to have_link('Sign in', href: signin_path) }
        end
      
        describe "using valid email" do
          before do
              visit edit_password_reset_path(user.reset_token, {
              email: user.email } )
          end
          it { expect(page).to have_button("Reset Now") }
          it { expect(page).to have_title("Password Reset") }
        end

        describe "submitting" do
          before do
              visit edit_password_reset_path(user.reset_token, {
              email: user.email})
          end
          describe  "with valid password" do
            before do
              fill_in 'Password',     with: "foobar"
              fill_in 'Confirmation', with: "foobar"
              click_button 'Reset Now'
            end
            it { expect(page).to have_title(user.name) }
          end
        end
      end


    end # end of password reset controller tests

end # end of suite