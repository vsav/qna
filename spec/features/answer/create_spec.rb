require 'rails_helper'

feature 'Authenticated can answer the questions', %q{
  In order to help someone from a community
  As an authenticated user
  I'd like to be able to answer the questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer for question' do
      fill_in 'Body', with: 'Answer text'
      click_on 'Create answer'

      expect(page).to have_content 'Answer was successfully created.'
      expect(page).to have_content 'Answer text'
      expect(current_path).to eq question_path(question)
    end

    scenario 'create answer with invalid attributes' do
      fill_in 'Body', with: ''
      click_on 'Create answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'create answer for question' do
      visit question_path(question)
      expect(page).to have_content 'You need to sign in or sign up to answer the questions'
      expect(page).to_not have_link 'Create answer'
    end
  end
end
