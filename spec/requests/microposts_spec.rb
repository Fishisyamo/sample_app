require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe 'Post /microposts request' do
    it 'successfully post when login user' do
      user      = FactoryBot.create(:user)
      micropost = FactoryBot.attributes_for(:micropost, user: user)
      is_log_in(user)
      expect do
        post microposts_path, params: { micropost: micropost }
      end.to change(Micropost, :count).by(1)
    end

    it 'redirect create when not logged in' do
      expect do
        post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
      end.to_not change(Micropost, :count)
      expect(response).to redirect_to login_url
    end
  end

  describe 'Destroy /micropost request' do
    it 'redirect destroy when not logged in' do
      micropost = FactoryBot.create(:micropost, :orange)
      expect do
        delete micropost_path(micropost)
      end.to_not change(Micropost, :count)
      expect(response).to redirect_to login_url
    end

    it 'redirect destroy when other user' do
      other     = FactoryBot.create(:user, name: 'Other User')
      micropost = FactoryBot.create(:micropost)
      is_log_in(other)
      expect do
        delete micropost_path(micropost)
      end.to_not change(Micropost, :count)
      expect(response).to redirect_to root_url
    end
  end
end
