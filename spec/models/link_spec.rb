# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'Link type and validness' do
    let(:question) { create(:question) }
    let(:link1) { build(:link, :valid_url, linkable: question) }
    let(:link2) { build(:link, :valid_gist, linkable: question) }
    let(:link3) { build(:link, :invalid_url, linkable: question) }

    it 'is valid ordinary url' do
      expect(link1).to be_valid
      expect(link1).to_not be_gist
    end

    it 'is valid gist' do
      expect(link2).to be_valid
      expect(link2).to be_gist
    end

    it 'is invalid ordinary url' do
      expect(link3).to be_invalid
    end
  end
end
