require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  scenario '#home' do
    visit root_path
    expect(page).to_not have_title 'Home | '
    expect(page).to have_title 'Ruby on Rails Tutorial Sample App'
    expect(page).to have_link 'sample app', href: root_path
    expect(page).to have_link 'Home', href: root_path
    expect(page).to have_link 'Help', href: help_path
    expect(page).to have_link 'About', href: about_path
    expect(page).to have_link 'Contact', href: contact_path
    expect(page).to have_link 'Sign up now!', href: signup_path
  end

  scenario '#help' do
    visit help_path
    expect(page).to have_title 'Help | Ruby on Rails Tutorial Sample App'
  end

  scenario '#about' do
    visit about_path
    expect(page).to have_title 'About | Ruby on Rails Tutorial Sample App'
  end

  scenario '#contact' do
    visit contact_path
    expect(page).to have_title 'Contact | Ruby on Rails Tutorial Sample App'
  end
end
