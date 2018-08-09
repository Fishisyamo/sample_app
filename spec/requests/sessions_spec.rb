require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  context 'Get /login requests' do
    it 'login with remember_me checked' do
      user = FactoryBot.create(:user)
      is_log_in(user, remember_me: '1')
      expect(is_logged_in?).to be_truthy
      expect(cookies['remember_token']).to_not be_nil
    end

    it 'login with remember_me unchecked' do
      user = FactoryBot.create(:user)
      is_log_in(user)
      expect(cookies['remember_token']).to be_nil
    end
  end

  context 'Destroy /logout requests' do
    it 'duplicate logout request passed' do
      user = FactoryBot.create(:user)
      is_log_in(user)
      delete logout_path
      # ログアウト後に別のウィンドウで再度ログアウト
      delete logout_path
    end
  end
end
