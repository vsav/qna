# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:comment3) { create(:comment, commentable: question, user: user) }
  let!(:comment1) { create(:comment, commentable: question, user: user) }
  let!(:comment2) { create(:comment, commentable: question, user: user) }

  it { should belong_to :user }
  it { should belong_to :commentable }
  it { should validate_presence_of(:body) }

  describe 'comments order' do
    it 'ordered by creation time' do
      expect(question.comments).to eq([comment3, comment1, comment2])
    end
  end
end
