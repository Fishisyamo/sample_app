require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  def login_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email:       user.email,
                                          password:    password,
                                          remember_me: remember_me } }
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  context 'Get /login requests' do
    it 'login with remember_me checked' do
      user = FactoryBot.create(:user)
      login_as(user)
      expect(is_logged_in?).to be_truthy
      expect(cookies['remember_token']).to_not be_nil
    end

    it 'login with remember_me unchecked' do
      user = FactoryBot.create(:user)
      login_as(user, remember_me: '0')
      expect(cookies['remember_token']).to be_nil
    end
  end

  context 'Destroy /logout requests' do
    it 'duplicate logout request passed' do
      user = FactoryBot.create(:user)
      login_as(user)
      delete logout_path
      # ログアウト後に別のウィンドウで再度ログアウト
      delete logout_path
    end
  end
end
