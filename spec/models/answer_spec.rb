require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer1) { create(:answer, question: question, user: user, best: true) }
  let!(:answer2) { create(:answer, question: question, user: user) }
  let!(:answer3) { create(:answer, question: question, user: user) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:best).on(:create) }

  describe 'answer mark_best' do

    before do
      answer2.mark_best!
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
  end

  describe 'best answer renders on top' do
    it 'best answer should be first in array' do
      expect(question.answers.best).to eq([question.answers.first])
    end
  end
end
