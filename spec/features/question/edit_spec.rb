require 'rails_helper'

feature 'User can edit own question', %q{
  In order to edit my question for some reason
  As a question's author
  I'd like to be able to edit my question
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:user2) { create(:user) }
    given(:question) { create(:question, user: user) }

    scenario 'author trying to edit own question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
      expect(page).to have_field('Title', with: question.title)
      expect(page).to have_field('Body', with: question.body)
      fill_in 'Title', with: 'Another title'
      click_on 'Ask question'
      expect(page).to have_content 'Question was successfully updated.'
    end

    scenario 'author trying to edit own question with invalid params' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
      fill_in 'Title', with: ''
      click_on 'Ask question'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'user trying to edit other users question' do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question) }
    scenario 'trying to edit question' do
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end
  end
end
