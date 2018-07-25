require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  scenario '#home have title' do
    visit root_url
    expect(page).to have_title 'Home'
  end

  scenario '#help have title' do
    visit static_pages_help_url
    expect(page).to have_title 'Help'
  end

  scenario '#about have title' do
    visit static_pages_about_url
    expect(page).to have_title 'About'
  end

  scenario '#contact have title' do
    visit 'static_pages/contact'
    expect(page).to have_title 'Contact'
  end
end
