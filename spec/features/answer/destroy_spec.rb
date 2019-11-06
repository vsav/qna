require 'rails_helper'
feature 'Delete answer', %q{
  In order to remove my answer
  As an authenticated user
  I'd like to be able to delete answer
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  describe 'Authenticated user' do

    scenario 'delete own answer' do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content answer.body
      click_on 'Delete answer'
      expect(page).to have_content 'Answer was successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'delete other users answer' do
      user2 = create(:user)
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'delete answer for question' do
      visit question_path(question)
      expect(page).to_not have_link 'Delete answer'
    end
  end
end
