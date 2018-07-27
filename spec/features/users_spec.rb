require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario '#new' do
    visit signup_path
    expect(page).to have_title 'Sign up | Ruby on Rails Tutorial Sample App'
    expect(page).to have_content 'Sign up'
  end
end
