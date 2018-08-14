require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    before do
      @user                  = FactoryBot.create(:user, activated: false, activated_at: nil)
      @user.activation_token = User.new_token
      @mail                  = UserMailer.account_activation(@user)
    end

    it 'renders the headers' do
      expect(@mail.subject).to eq 'Account activation'
      expect(@mail.to).to eq [@user.email]
      expect(@mail.from).to eq ['noreply@example.com']
    end

    it 'renders the body' do
      expect(@mail.body.encoded).to match @user.name
      expect(@mail.body.encoded).to match @user.activation_token
      expect(@mail.body.encoded).to match CGI.escape(@user.email)
    end
  end

  context 'password_reset' do
    before do
      @user             = FactoryBot.create(:user)
      @user.reset_token = User.new_token
      @mail             = UserMailer.password_reset(@user)
    end

    it 'renders the headers' do
      expect(@mail.subject).to eq 'Password reset'
      expect(@mail.to).to eq [@user.email]
      expect(@mail.from).to eq ['noreply@example.com']
    end

    it 'renders the body' do
      expect(@mail.body.encoded).to match @user.reset_token
      expect(@mail.body.encoded).to match CGI.escape(@user.email)
    end
  end
end
