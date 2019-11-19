require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As a answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:url) { 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Ruby_On_Rails_Logo.svg/1200px-Ruby_On_Rails_Logo.svg.png' }

  scenario 'User add link when answers the question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer-form' do
      fill_in 'Body', with: 'answer answer answer'
      fill_in 'Link name', with: 'My pic'
      fill_in 'Url', with: url

      click_on 'Create answer'
    end

    within '.answers' do
      expect(page).to have_link 'My pic', href: url
    end

  end
end
