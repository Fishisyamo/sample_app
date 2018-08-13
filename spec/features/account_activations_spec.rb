require 'rails_helper'

RSpec.feature "AccountActivations", type: :feature do
  let(:user) { FactoryBot.create(:user, activated: false, activated_at: nil) }

  scenario 'login when non account activation' do
    visit login_path
    log_in_as(user)

    expect(current_path).to eq root_path
    message = 'Account not activated. '
    message += 'Check your email for the activation link.'
    expect(page).to have_css 'div.alert-warning', text: message
    expect(user.activated).to be_falsey
  end

  scenario 'invalid token' do
    visit edit_account_activation_path('invalid token', email: user.email)

    expect(page).to have_css 'div.alert-danger', text: 'Invalid activation link'
    expect(current_path).to eq root_path
    expect(user.reload.activated).to be_falsey
  end

  scenario 'invalid email' do
    visit edit_account_activation_path(user.activation_token, email: 'invalid@mail.com')

    expect(page).to have_css 'div.alert-danger', text: 'Invalid activation link'
    expect(current_path).to eq root_path
    expect(user.reload.activated).to be_falsey
  end

  scenario 'valid token and email' do
    visit edit_account_activation_path(user.activation_token, email: user.email)

    expect(page).to have_css 'div.alert-success', text: 'Account activated!'
    expect(current_path).to eq user_path(user)
    expect(user.reload.activated).to be_truthy
  end
end
