require 'rails_helper'

feature 'User can delete own question', %q{
  In order to delete my question for some reason
  As a question's author
  I'd like to be able to delete my question
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    scenario 'author trying to delete own question' do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content question.title
      click_on 'Delete question'
      expect(page).to have_content 'Question was successfully deleted.'
      expect(page).to_not have_content question.title
    end

    scenario 'user trying to delete other users question' do
      user2 = create(:user)
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Delete question'
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question) }
    scenario 'trying to delete question' do
      visit question_path(question)
      expect(page).to_not have_link 'Delete question'
    end
  end
end
