require "spec_helper"

describe UserMailer do

	let(:user) { FactoryGirl.create(:user) }

	describe "Registration Confirmation mail" do
		let(:mail) { UserMailer.registration_confirmation(user) }
		it {expect(mail.subject).to eq(full_title("Registration Confirmation for #{ user.name }")) }

		# puts mail.content
		it {expect(mail.to).to have_content("#{user.email}") }
		pending "To: address test needs refining" 
		# it { expect(mail.body).to have_link(user_url(user)) }

	end
  
end
