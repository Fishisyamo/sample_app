require 'rails_helper'

RSpec.feature "Users", type: :feature do
  feature '#signup features' do
    background do
      visit signup_path
    end

    scenario 'have title' do
      expect(page).to have_title is_full_title('Sign up')
      expect(page).to have_content 'Sign up'
    end

    scenario 'when invalid submit' do
      click_button 'Create my account'

      expect(current_path).to eq signup_path
      expect(page).to have_css 'div.alert-danger'
      expect(page).to have_selector 'div#error_explanation ul li'
    end

    context 'when valid submit' do
      include ActionMailer::TestHelper
      after do
        ActionMailer::Base.deliveries.clear
      end

      scenario 'send an account activation mail after create account' do
        perform_enqueued_jobs do
          expect {
            fill_in 'Name', with: 'Test User'
            fill_in 'Email', with: 'example@test.com'
            fill_in 'Password', with: 'password'
            fill_in 'Confirmation', with: 'password'
            click_button 'Create my account'
          }.to change(User, :count).by(1)

          expect(current_path).to eq root_path
          expect(page).to have_css 'div.alert-info'
          expect(page).to have_content 'Please check your email to activate your account.'
          expect(page).to have_link 'Log in', href: login_path
          expect(ActionMailer::Base.deliveries.size).to eq 1
        end
      end
    end
  end

  feature '#index features' do
    scenario 'paginate' do
      login_user = FactoryBot.create(:user)
      30.times { FactoryBot.create(:user) }
      log_in_as(login_user)
      visit users_path

      expect(current_path).to eq users_path
      expect(page).to have_selector 'div.pagination', count: 2
      User.paginate(page: 1).each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end

  feature '#edit features' do
    context 'visit user edit form' do
      scenario 'redirect to login path when not logged in' do
        user = FactoryBot.create(:user)
        visit edit_user_path(user)

        expect(current_path).to eq login_path
        expect(page).to have_css 'div.alert-danger', text: 'Please log in.'
      end

      scenario 'redirect to root path when unauthorized user' do
        user       = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user, name: 'Other User')
        log_in_as(other_user)
        visit edit_user_path(user)

        expect(current_path).to eq root_path
      end

      scenario 'get visit success when authorized user' do
        user = FactoryBot.create(:user)

        log_in_as(user)
        visit edit_user_path(user)

        expect(current_path).to eq edit_user_path(user)
      end

      scenario 'successful edit with friendly forwarding' do
        user = FactoryBot.create(:user)
        visit edit_user_path(user)
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        click_button 'Log in'

        expect(current_path).to eq edit_user_path(user)
      end
    end

    context 'enter new status submit' do
      scenario 'when invalid submit' do
        user = FactoryBot.create(:user)
        log_in_as(user)
        visit edit_user_path(user)
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'example@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        click_button 'Save changes'

        expect(current_path).to eq edit_user_path(user)
        expect(page).to have_css 'div.alert-danger', text: 'The form contains 4 errors'
        expect(page).to have_selector 'div#error_explanation ul li'
      end

      scenario 'when valid submit' do
        user = FactoryBot.create(:user)
        log_in_as(user)
        visit edit_user_path(user)
        name  = 'Foo Bar'
        email = 'foo@bar.com'
        fill_in 'Name', with: name
        fill_in 'Email', with: email
        fill_in 'Password', with: ''
        fill_in 'Confirmation', with: ''
        click_button 'Save changes'

        expect(current_path).to eq user_path(user)
        expect(page).to have_css 'div.alert-success'
        user.reload
        expect(user.name).to eq name
        expect(user.email).to eq email
      end
    end
  end

  feature '#destroy feature', js: true do
    context 'login as admin and delete other user account' do
      background do
        user        = FactoryBot.create(:user, admin: true)
        @other_user = FactoryBot.create(:user, name: 'Other User')
        log_in_as(user)
        visit users_path
      end

      scenario 'have delete link' do
        expect(page).to have_link @other_user.name, href: user_path(@other_user)
        expect(page).to have_link 'delete', href: user_path(@other_user)
        link = find_link 'delete'
        expect(link['data-confirm']).to eq 'You sure?'
      end

      scenario 'accepting a confirm' do
        page.accept_confirm 'You sure?' do
          click_link 'delete'
        end
        expect(current_path).to eq users_path
        expect(page).to have_css 'div.alert-success', text: 'User deleted'
        expect(page).to have_no_link @other_user.name, href: user_path(@other_user)
      end

      scenario 'dismissing a confirm' do
        page.dismiss_confirm 'You sure?' do
          click_link 'delete'
        end
        expect(current_path).to eq users_path
        expect(page).to have_no_css 'div.alert-success', text: 'User deleted'
        expect(page).to have_link @other_user.name, href: user_path(@other_user)
      end
    end

    context 'delete link is hidden when logged in non admin user' do
      scenario 'have not delete link' do
        user       = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user, name: 'Other User')

        log_in_as(user)
        visit users_path

        expect(page).to have_link other_user.name, href: user_path(other_user)
        expect(page).to have_no_link 'delete', href: user_path(other_user)
      end
    end
  end

  feature '#show feature' do
    context 'profile display' do
      let(:user) { FactoryBot.create(:user) }

      scenario 'have title and gravatar img' do
        log_in_as(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_title is_full_title(user.name)
        expect(page).to have_selector 'h1', text: user.name
        expect(page).to have_selector 'h1>img.gravatar'
      end

      scenario 'show microposts and pagination' do
        31.times { FactoryBot.create(:micropost, :faker, user: user) }
        log_in_as(user)

        expect(page).to have_selector 'div.pagination', count: 1
        expect(page).to have_content user.microposts.count.to_s
        user.microposts.paginate(page: 1).each do |micropost|
          expect(page).to have_content micropost.content
        end
      end
    end
  end
end
