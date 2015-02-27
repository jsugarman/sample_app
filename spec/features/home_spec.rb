require 'spec_helper'

feature 'Home' do
	background { visit root_url }
	it 'should not have JavaScript errors', js: true do
		pending "need a failed test example - this does not work"
		expect(page).not_to have_errors
	end
end