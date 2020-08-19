# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  subject { user }

  context 'validation valid' do
    it { is_expected.to be_valid }
  end

  context 'account_name include !@' do
    it 'account_name validation invalid' do
      user.account_name = '!fjafknef@'
      is_expected.to be_invalid
      expect(user.errors.full_messages[0]).to eq 'Account nameは英数字のみが使えます'
    end
  end

  context 'password under the length 6' do
    it 'password validation invalid' do
      password_invalid = User.create(password: 'test', password_confirmation: 'test')
      expect(password_invalid.errors.full_messages[0]).to eq 'Passwordは6文字以上で入力してください'
    end
  end

  context 'when account_name duplicate' do
    it 'unique validation invalid' do
      invalid = User.create(account_name: user.account_name, password: 'test12', password_confirmation: 'test12')
      expect(invalid.errors.full_messages[0]).to eq 'Account nameはすでに存在します'
    end
  end
end
