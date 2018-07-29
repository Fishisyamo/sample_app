require 'rails_helper'

RSpec.feature "Users", type: :feature do
  context '#signup' do
    before do
      visit signup_path
    end

    scenario 'have title' do
      expect(page).to have_title 'Sign up | Ruby on Rails Tutorial Sample App'
      expect(page).to have_content 'Sign up'
    end

    scenario 'invalid submit' do
      click_button 'Create my account'

      expect(page).to have_current_path '/signup'
      expect(page).to have_css 'div.alert-danger'
      expect(page).to have_selector 'div#error_explanation ul li'
    end

    scenario 'valid submit' do
      fill_in 'Name', with: 'valid user'
      fill_in 'Email', with: 'valid@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Confirmation', with: 'password'
      click_button 'Create my account'

      expect(page).to have_current_path '/users/1'
      expect(page).to have_css 'div.alert-success'
      expect(page).to have_content 'Welcome to the Sample App!'
    end
  end
end
