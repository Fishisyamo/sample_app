require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'Get /users request' do
    context 'as a guest' do
      it 'redirect to login path' do
        get users_path
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'Patch /users/:id/edit request' do
    context 'as a guest' do
      it 'update failed and redirect to loin_path' do
        user = FactoryBot.create(:user)
        name = 'Changed Name'
        patch edit_user_path(user),
              params: { user: { name: name } }

        user.reload
        expect(user.name).to_not eq name
        expect(response).to redirect_to login_path
      end
    end

    context 'as an unauthorized user' do
      it 'update failed and redirect to root_path' do
        user       = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user, name: 'Other User')
        name       = 'Changed Name'

        is_log_in(other_user)
        patch edit_user_path(user),
              params: { user: { name: name } }

        user.reload
        expect(user.name).to_not eq name
        expect(response).to redirect_to root_path
      end
    end

    context 'as an authorized user' do
      it 'status update succeeds' do
        user = FactoryBot.create(:user)
        name = 'Changed Name'

        is_log_in(user)
        patch edit_user_path(user),
              params: { user: { name: name } }

        user.reload
        expect(user.name).to eq name
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'about admin attribute' do
      it 'should not allow the admin attribute to edited via the web' do
        user = FactoryBot.create(:user)
        is_log_in(user)
        patch edit_user_path(user),
              params: { user: { admin: true } }

        user.reload
        expect(user.admin).to_not be_truthy
      end
    end
  end

  describe 'Destroy /users request' do
    before do
      @user       = FactoryBot.create(:user, admin: true)
      @other_user = FactoryBot.create(:user)
    end

    context 'as a guest' do
      it 'delete failed and redirect to login_path' do
        expect { delete user_path(@other_user) }.to_not change(User, :count)
        expect(response).to redirect_to login_path
      end
    end

    context 'as an non admin' do
      it 'delete failed and redirect to root_path' do
        is_log_in(@other_user)
        expect { delete user_path(@user) }.to_not change(User, :count)
        expect(response).to redirect_to root_path
      end
    end

    context 'as an admin' do
      it 'successfully deleted and redirect to users_path' do
        is_log_in(@user)
        expect { delete user_path(@other_user) }.to change(User, :count).by(-1)
        expect(response).to redirect_to users_path
      end
    end
  end
end
