require 'rails_helper'
feature 'Edit answer', %q{
  In order to edit my answer
  As an answer author
  I'd like to be able to edit answer
} do

  given(:author) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do

    scenario 'edit own answer' do
      sign_in(author)
      answer = create(:answer, author: author, question: question)
      visit question_path(question)
      click_on 'Edit answer'
      expect(page).to have_field('Body', with: answer.body)
    end

    scenario 'edit other users answer' do
      user = create(:user)
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_content 'Edit answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'edit answer for question' do
      visit question_path(question)
      expect(page).to_not have_content 'Edit answer'
    end
  end
end
