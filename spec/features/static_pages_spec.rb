require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  feature '#home' do
    scenario '#home not have page title' do
      visit root_path
      expect(page).to_not have_title 'Home | '
    end

    scenario '#home have full_title only' do
      visit root_path
      expect(page).to have_title 'Ruby on Rails Tutorial Sample App'
    end
  end

  scenario '#help have title' do
    visit static_pages_help_path
    expect(page).to have_title 'Help'
  end

  scenario '#about have title' do
    visit static_pages_about_path
    expect(page).to have_title 'About'
  end

  scenario '#contact have title' do
    visit 'static_pages/contact'
    expect(page).to have_title 'Contact'
  end
end
