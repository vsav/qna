require 'rails_helper'
require "#{Rails.root}/app/validators/email_validator"

describe EmailValidator, type: :model do
  subject { User.new email: 'user@test.com', password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now }

  it { is_expected.to be_valid }

  context 'without username' do
    it 'is invalid' do
      subject.email = '@test.com'
      subject.valid?
      expect(subject.errors[:email]).to include('must be a valid email format')
    end
  end

  context 'without domain extension' do
    it 'is invalid' do
      subject.email = 'user@test'
      subject.valid?
      expect(subject.errors[:email]).to include('must be a valid email format')
    end
  end

  context 'without @' do
    it 'is invalid' do
      subject.email = 'usertest.com'
      subject.valid?
      expect(subject.errors[:email]).to include('must be a valid email format')
    end
  end

  context 'with additional symbols' do
    it 'is valid' do
      subject.email = 'user@test-2.com'
      subject.valid?
      expect(subject.errors[:email]).to_not include('must be a valid email format')
    end
  end

  context 'with additional invalid symbols' do
    it 'is invalid' do
      subject.email = 'user@test@.com'
      subject.valid?
      expect(subject.errors[:email]).to include('must be a valid email format')
    end
  end

  context 'with additional invalid domain extension' do
    it 'is invalid' do
      subject.email = 'user@test.com2'
      subject.valid?
      expect(subject.errors[:email]).to include('must be a valid email format')
    end
  end

end
