require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }

  describe 'answer mark_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question, user: user, best: true) }
    let!(:answer2) { create(:answer, question: question, user: user) }

    before do
      answer2.mark_best
      answer2.reload
      answer1.reload
    end

    it 'should mark answer2 as best' do
      expect(answer2).to be_best
    end

    it 'should change best answer' do
      expect(answer1).to_not be_best
      expect(answer2).to be_best
    end

    it 'only one answer can be marked as best' do
      expect(question.answers.best.count).to eq 1
    end

    it 'best answer is on top' do
      expect(answer2).to eq question.answers.first
    end
  end
end
