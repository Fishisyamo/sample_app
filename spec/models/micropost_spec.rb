require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { FactoryBot.build(:micropost) }

  it 'should be valid' do
    expect(micropost).to be_valid
  end

  it 'user id should be present' do
    micropost.user_id = nil
    expect(micropost).to_not be_valid
  end

  it 'content should be present' do
    micropost.content = '    '
    expect(micropost).to_not be_valid
  end

  it 'context should be at most 140 characters' do
    micropost.content = 'a' * 141
    expect(micropost).to_not be_valid
  end

  it 'order should be most resent first' do
    user = FactoryBot.create(:user) # ここで同じユーザーに揃える必要はない
    FactoryBot.create(:micropost, :orange, user: user)
    FactoryBot.create(:micropost, :tau_manifest, user: user)
    FactoryBot.create(:micropost, :cat_video, user: user)
    most_recent = FactoryBot.create(:micropost, :most_recent, user: user)

    expect(Micropost.first).to eq most_recent
  end
end
