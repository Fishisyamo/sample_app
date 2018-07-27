require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name:     'Bob Dylan', email: 'rolling_stone@example.com',
                     password: 'password', password_confirmation: 'password')
  end

  it 'is valid a user' do
    expect(@user).to be_valid
  end

  context 'name' do
    it 'is invalid without a name' do
      @user.name = nil
      @user.valid?
      expect(@user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid name with 51 or more characters' do
      @user.name = 'a' * 51
      @user.valid?
      expect(@user.errors[:name]).to include("is too long (maximum is 50 characters)")
    end
  end

  context 'email' do
    it 'is invalid without a email' do
      @user.email = nil
      @user.valid?
      expect(@user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid email with 255 or more characters' do
      @user.email = 'a' * 244 + '@example.com'
      @user.valid?
      expect(@user.errors[:email]).to include("is too long (maximum is 255 characters)")
    end

    it 'is invalid with a duplicate email address' do
      other_user = @user.dup
      other_user.email.upcase!
      @user.save
      other_user.valid?
      expect(other_user.errors[:email]).to include("has already been taken")
    end

    it 'should be saved as lower-case' do
      mixed_case_email = 'FooBar@ExaMPlE.cOm'
      @user.email      = mixed_case_email
      @user.save
      expect(@user.email).to eq mixed_case_email.downcase
    end

    context 'address format' do
      it 'is valid' do
        valid_addresses = %w[User@foo.COM THE_US-ER@foo.bar.org first.last@foo.jp]
        valid_addresses.each do |address|
          @user.email = address
          expect(@user).to be_valid, "#{address.inspect} should be invalid"
        end
      end

      it 'is invalid' do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |address|
          @user.email = address
          expect(@user).to be_invalid, "#{address.inspect} should be valid"
        end
      end
    end
  end

  context 'password' do
    it 'is should be present (nonblank)' do
      @user.password = @user.password_confirmation = ' ' * 6
      expect(@user).to be_invalid
    end

    it 'is should have a minimum length' do
      @user.password = @user.password_confirmation = 'a' * 5
      expect(@user).to be_invalid
    end
  end
end
