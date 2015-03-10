require "spec_helper"

describe UserMailer do

	let(:user) { FactoryGirl.create(:user) }

	describe "Registration Confirmation mail" do
		let(:mail) { UserMailer.registration_confirmation(user) }
		
		it { expect(mail.to).to have_content("#{user.email}") }
		it { expect(mail.subject).to eq(full_title("Registration Confirmation for #{ user.name }")) }
		it { expect(mail.body).to have_link('Check it Out', href: user_url(user)) }

		# it { expect(mail.body).to have_link("Confirm Signup") }
		
		pending "Body: confirm signup link must point to a activate user controller#action"
		pending "To: address test needs refining to include \"name <email>\" syntax" 
	end
  
end
