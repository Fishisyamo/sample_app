require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  context '#login features' do
    scenario 'have title' do
      visit login_path
      expect(page).to have_title 'Log in | Ruby on Rails Tutorial Sample App'
      expect(page).to have_content 'Log in'
    end

    scenario 'invalid submit' do
      visit login_path
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      click_button 'Log in'

      expect(page).to have_current_path '/login'
      expect(page).to have_css 'div.alert-danger'
      visit login_path
      expect(page).to have_no_css 'div.alert-danger'
    end

    scenario 'valid submit' do
      user = FactoryBot.create(:user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'

      expect(page).to have_current_path user_path(user)
      expect(page).to have_no_link 'Log in', href: login_path
      expect(page).to have_link 'Log out', href: logout_path
      expect(page).to have_link 'Profile', href: user_path(user)
    end
  end

  context '#logout features' do
    scenario 'logout success' do
      user = FactoryBot.create(:user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      click_link 'Log out'

      expect(page).to have_current_path root_path
      expect(page).to have_no_link 'Log out', href: logout_path
      expect(page).to have_no_link 'Profile', href: user_path(user)
    end
  end
end
