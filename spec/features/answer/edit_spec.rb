require 'rails_helper'
feature 'Edit answer', %q{
  In order to edit my answer
  As an answer author
  I'd like to be able to edit answer
} do
  given(:user) {create(:user) }
  given(:user2) {create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'edit own answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      expect(page).to have_field('Body', with: answer.body)
      fill_in 'Body', with: 'Another text'
      click_on 'Create answer'
      expect(page).to have_content 'Answer was successfully updated.'
      expect(page).to have_content 'Another text'
    end

    scenario 'edit own answer with invalid params' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      fill_in 'Body', with: ''
      click_on 'Create answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edit other users answer' do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'edit answer for question' do
      visit question_path(question)
      expect(page).to_not have_link 'Edit answer'
    end
  end
end
