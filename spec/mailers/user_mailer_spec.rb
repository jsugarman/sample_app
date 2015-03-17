require "spec_helper"

describe UserMailer do

	

	# describe "Registration Confirmation mail" do
	# 	let(:mail) { UserMailer.registration_confirmation(user) }
		
	# 	it { expect(mail.to).to have_content("#{user.email}") }
	# 	it { expect(mail.subject).to eq(full_title("Registration Confirmation for #{ user.name }")) }
	# 	it { expect(mail.body.encoded).to have_link('Check it Out', href: user_url(user)) }

	# 	pending "Body: confirm signup link must point to a activate user controller#action"
	# 	pending "To: address test needs refining to include \"name <email>\" syntax" 
	# end

	describe "account_activation" do
		let(:user) { FactoryGirl.create(:user) }
		let(:mail) { UserMailer.account_activation(user) }
		it "To: shoud have expected format" do expect(mail.to).to have_content("#{user.email}") end
		it "Subject: field should have expected text" do  expect(mail.subject).to eq(full_title("Activation Required for #{ user.name }")) end
		it "Body: should have Activate Link" do  expect(mail.body.encoded).to have_link('Activate', href: edit_account_activation_url(user.activation_token, email: user.email)) end
		it "Body: should greet user by name" do  expect(mail.body.encoded).to have_content("Hi #{user.name}") end
	end

	describe "password_reset" do
		let(:user) { FactoryGirl.create(:user) }
		before do 
			user.create_reset_digest
		end	
		after do
 			user.destroy!
 			# TODO find way to NOT have to explicitly delete test record
		end
		describe "for one user" do
			let(:mail) { UserMailer.password_reset(user) }
			it "From: " do expect(mail.from).to have_content("rortestmailer@gmail.com") end
			it "To: shoud have expected format" do expect(mail.to).to have_content("#{user.email}") end
			it "Subject: field should have expected text" do  expect(mail.subject).to eq(full_title("Password reset requested for #{user.name}")) end
			it "Body: should have reset Link" do expect(mail.body.encoded).to have_link("reset", href: edit_password_reset_url(user.reset_token,email: user.email)) end
			it "Body: should greet user by name" do  expect(mail.body.encoded).to have_content("Hi #{user.name}") end
 		end
	end

end
