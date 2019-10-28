require 'rails_helper'

feature 'User can edit own question', %q{
  In order to edit my question for some reason
  As a question's author
  I'd like to be able to edit my question
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:author) { create(:user) }
    given(:question) { create(:question, author: author) }

    scenario 'author trying to edit own question' do
      sign_in(author)
      visit question_path(question)
      click_on 'Edit question'
      expect(page).to have_field('Title', with: question.title)
      expect(page).to have_field('Body', with: question.body)
    end

    scenario 'user trying to edit other users question' do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_content 'Edit question'
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question) }
    scenario 'trying to edit question' do
      visit question_path(question)
      expect(page).to_not have_content 'Edit question'
    end
  end
end
