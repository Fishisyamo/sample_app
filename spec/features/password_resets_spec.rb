require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do
  include ActionMailer::TestHelper

  let(:user) { FactoryBot.create(:user) }

  after do
    ActionMailer::Base.deliveries.clear
  end

  context '#new feature' do
    scenario 'invalid Email address' do
      visit new_password_reset_path
      click_button 'Submit'

      expect(current_path).to eq password_resets_path
      expect(page).to have_css 'div.alert-danger', text: 'Email address not found'
      mail = ActionMailer::Base.deliveries
      expect(mail.size).to eq 0
    end

    scenario 'valid Email address' do
      visit new_password_reset_path
      fill_in 'Email', with: user.email
      click_button 'Submit'

      expect(current_path).to eq root_path
      expect(page).to have_css 'div.alert-info', text: 'Email sent with password reset instructions'
      expect(user.reset_digest).to_not eq user.reload.reset_digest
      mail = ActionMailer::Base.deliveries
      expect(mail.size).to eq 1
    end
  end

  context '#edit feature' do
    before do
      user.create_reset_digest
      user.reload
    end
    context 'page access' do
      scenario 'invalid email address' do
        visit edit_password_reset_path(user.reset_token, email: '')
        expect(current_path).to eq root_path
      end

      scenario 'invalid reset_token' do
        visit edit_password_reset_path('invalid', email: user.email)
        expect(current_path).to eq root_path
      end

      scenario 'valid reset_token and email address' do
        visit edit_password_reset_path(user.reset_token, email: user.email)
        expect(current_path).to eq edit_password_reset_path(user.reset_token)
        expect(find('input[name=email][type=hidden]', visible: false).value).to eq user.email
      end

      scenario 'expired reset_token' do
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        visit edit_password_reset_path(user.reset_token, email: user.email)
        expect(current_path).to eq new_password_reset_path
        expect(page).to have_css 'div.alert-danger'
        expect(page).to have_content 'Password reset has expired.'
      end
    end

    context 'form submit' do
      before do
        visit edit_password_reset_path(user.reset_token, email: user.email)
      end

      scenario 'when invalid submit' do
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        click_button 'Update password'

        expect(current_path).to eq password_reset_path(user.reset_token)
        expect(page).to have_css 'div.alert-danger'
      end

      scenario 'when empty submit' do
        click_button 'Update password'
        expect(current_path).to eq password_reset_path(user.reset_token)
        expect(page).to have_css 'div.alert-danger'
        expect(page).to have_content "Password can't be blank"
      end

      scenario 'when valid submit' do
        password = user.password_digest
        fill_in 'Password', with: 'newpassword'
        fill_in 'Confirmation', with: 'newpassword'
        click_button 'Update password'

        user.reload
        expect(current_path).to eq user_path(user)
        expect(page).to have_css 'div.alert-success', text: 'Password has been reset.'
        expect(page).to have_link 'Log out', href: logout_path
        expect(password).to_not eq user.reload.password_digest
        expect(user.reset_digest).to be_nil
      end

      scenario 'valid submit when expired reset_token' do
        password = user.password_digest
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        user.reload
        fill_in 'Password', with: 'newpassword'
        fill_in 'Confirmation', with: 'newpassword'
        click_button 'Update password'

        expect(current_path).to eq new_password_reset_path
        expect(page).to have_css 'div.alert-danger'
        expect(page).to have_content 'Password reset has expired.'
        expect(password).to eq user.reload.password_digest
      end
    end
  end
end
