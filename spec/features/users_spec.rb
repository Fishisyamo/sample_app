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
      user = FactoryBot.build(:user)
      fill_in 'Name', with: user.name
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Confirmation', with: user.password
      click_button 'Create my account'
      create_user = User.find_by(email: user.email)

      expect(page).to have_current_path user_path(create_user)
      expect(page).to have_css 'div.alert-success'
      expect(page).to have_content 'Welcome to the Sample App!'
      expect(page).to have_link 'Log out', href: logout_path
    end
  end
end
