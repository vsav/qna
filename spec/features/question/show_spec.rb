require 'rails_helper'

feature 'User can see questions and answers for them', %q{
  In order to get answer from a community
  As an authenticated or unauthenticated user
  I'd like to be able to see the answers for questions
} do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given(:answers) { create_list(:answer, 3, question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can see question body' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'can see answers for question' do
      question.answers.each { |answer| expect(page).to have_content answer.body }
    end
  end

  describe 'Unauthenticated user' do
    before { visit question_path(question) }
    scenario 'can see question body' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'can see answers for question' do
      question.answers.each { |answer| expect(page).to have_content answer.body }
    end
  end
end
