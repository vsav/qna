# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/app/validators/url_validator"

describe UrlValidator, type: :model do
  subject { Link.new name: 'url', url: 'http://example.com', linkable: Question.new }

  it { is_expected.to be_valid }

  context 'without protocol' do
    it 'is invalid' do
      subject.url = 'example.com'
      subject.valid?
      expect(subject.errors[:url]).to match_array('must be a valid URL format')
    end
  end

  context 'without domain extension' do
    it 'is invalid' do
      subject.url = 'http://example'
      subject.valid?
      expect(subject.errors[:url]).to match_array('must be a valid URL format')
    end
  end

  context 'with additional symbols' do
    it 'is valid' do
      subject.url = 'http://example-2.com'
      subject.valid?
      expect(subject.errors[:url]).to_not match_array('must be a valid URL format')
    end
  end

  context 'with additional path' do
    it 'is valid' do
      subject.url = 'http://example.com/path'
      subject.valid?
      expect(subject.errors[:url]).to_not match_array('must be a valid URL format')
    end
  end

  context 'with additional invalid symbols' do
    it 'is invalid' do
      subject.url = 'http://example@.com'
      subject.valid?
      expect(subject.errors[:url]).to match_array('must be a valid URL format')
    end
  end

  context 'with additional invalid domain extension' do
    it 'is invalid' do
      subject.url = 'http://example.com2'
      subject.valid?
      expect(subject.errors[:url]).to match_array('must be a valid URL format')
    end
  end
end
