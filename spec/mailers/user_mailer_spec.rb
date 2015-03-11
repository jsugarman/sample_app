require "spec_helper"

describe UserMailer do

	let(:user) { FactoryGirl.create(:user) }

	# describe "Registration Confirmation mail" do
	# 	let(:mail) { UserMailer.registration_confirmation(user) }
		
	# 	it { expect(mail.to).to have_content("#{user.email}") }
	# 	it { expect(mail.subject).to eq(full_title("Registration Confirmation for #{ user.name }")) }
	# 	it { expect(mail.body.encoded).to have_link('Check it Out', href: user_url(user)) }

	# 	pending "Body: confirm signup link must point to a activate user controller#action"
	# 	pending "To: address test needs refining to include \"name <email>\" syntax" 
	# end


	describe "Account Activation mail" do
		let(:mail) { UserMailer.account_activation(user) }
		
		it "shoud be To: user email" do expect(mail.to).to have_content("#{user.email}") end
		it "should have subject reflecting Activation Required" do  expect(mail.subject).to eq(full_title("Activation Required for #{ user.name }")) end
		it "should have Activate Link" do  expect(mail.body.encoded).to have_link('Activate', href: edit_account_activation_url(user.activation_token, email: user.email)) end
		it "should greet user by name" do  expect(mail.body.encoded).to have_content("Hi #{user.name}") end
		# it "should have activation token" do  expect(mail.body.encoded).to have_content(user.activation_token) end
		# it "should contain escaped user email address: " do expect(mail.body.encoded).to have_content(CGI::escape(user.email)) end

		pending "Body: confirm activation link must point to a activate user controller#action"
		pending "To: address test needs refining to include \"name <email>\" syntax" 
	end


  
end
