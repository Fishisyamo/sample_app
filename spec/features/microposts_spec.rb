# features/users_specのshowで書くのが不自然に感じてきたらこちらに移行する

require 'rails_helper'

RSpec.feature "Microposts", type: :feature do
  # include CarrierWave::Test::Matchers
  context 'Post feature' do
    before do
      @user = FactoryBot.create(:user)
      log_in_as(@user)
      visit root_path
    end

    # scenario 'invalid post when content blank' do
    #   expect do
    #     pending
    #     click_button 'Post'
    #   end.to_not change(Micropost, :count)
    #   expect(page).to have_css 'div#error_explanation'
    # end
    #
    # scenario 'valid post' do
    #   pending
    #   content = 'This micropost really ties the room together'
    #   expect do
    #     fill_in 'micropost_content', with: content
    #     click_button 'Post'
    #   end.to change(Micropost, :count).by(1)
    #   expect(current_path).to eq root_path
    # end

    scenario 'micropost sidebar count' do
      expect(page).to have_content('0 microposts')
      FactoryBot.create(:micropost, user: @user)
      visit root_path
      expect(page).to have_content('1 micropost')
    end

    scenario 'successfully a picture upload' do
      content = 'This micropost really ties the room together'
      expect do
        fill_in 'micropost_content', with: content
        attach_file 'micropost_picture', "#{Rails.root}/spec/files/test_image.jpg"
        click_button 'Post'
      end.to change(Micropost, :count).by(1)
      expect(current_path).to eq root_path
    end

    scenario 'successfully a picture upload' do
      # content = ''
      expect do
        # fill_in 'micropost_content', with: content
        attach_file 'micropost_picture', "#{Rails.root}/spec/files/test_image.jpg"
        click_button 'Post'
      end.to change(Micropost, :count).by(0)

      expect(page).to have_content 'The form contains 1 error'
      # end.to be_valid
      # expect(current_path).to eq root_path
    end
  end

  context 'Delete feature', js: true do
    let(:user) { FactoryBot.create(:user) }

    context 'own micropost' do
      before do
        FactoryBot.create(:micropost, user: user)
        log_in_as(user)
      end

      scenario 'accepting a confirm' do
        expect do
          page.accept_confirm 'Your sure?' do
            click_link 'delete'
          end
        end.to change(Micropost, :count).by(-1)
        expect(current_path).to eq user_path(user)
        expect(page).to have_css 'div.alert-success', text: 'Micropost deleted'
      end

      scenario 'dismissing a confirm' do
        expect do
          page.dismiss_confirm 'Your sure?' do
            click_link 'delete'
          end
        end.to change(Micropost, :count).by(0)
        expect(current_path).to eq user_path(user)
      end
    end

    context 'other user profile' do
      scenario 'hide delete_link' do
        other = FactoryBot.create(:user, name: 'Other')
        FactoryBot.create(:micropost, user: other)
        visit user_path(other)

        expect(page).to have_no_link 'delete'
      end
    end
  end
end
