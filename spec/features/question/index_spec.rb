require 'rails_helper'

feature 'User can see questions list', %q{
  In order to get answer from a community
  As an authenticated or unauthenticated user
  I'd like to be able to see the questions
} do
    given!(:questions) { create_list(:question, 3) }
    given(:user) { create(:user) }
    scenario 'Authenticated user can see questions list' do
      sign_in(user)
      visit questions_path
      questions.each { |question| expect(page).to have_content question.title }
    end

    scenario 'Unauthenticated user can see questions list' do
      visit questions_path
      questions.each { |question| expect(page).to have_content question.title }
    end
end
