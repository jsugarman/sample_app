require 'spec_helper'

feature 'Javascript Error Testing' do
	# 
	# DatabaseCleaner truncation of db causing problems 
	# 
	pending "Capybara::Webkit needed - see file for details"

	# background { visit root_url }
	# it 'set js: true to activate', js: false do
	# 	pending "need a failed test example - this does not work"
	# 	expect(page).not_to have_errors
	# end
end