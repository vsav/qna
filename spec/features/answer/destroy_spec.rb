require 'rails_helper'
feature 'Delete answer', %q{
  In order to remove my answer
  As an authenticated user
  I'd like to be able to delete answer
} do

  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  describe 'Authenticated user' do

    scenario 'delete own answer' do
      sign_in(author)
      answer = create(:answer, author: author, question: question)
      visit question_path(question)
      click_on 'Delete answer'
      expect(page).to have_content 'Answer was successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'delete other users answer' do
      create(:answer, author: author, question: question)
      user = create(:user)
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_content 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'delete answer for question' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete answer'
    end
  end
end
