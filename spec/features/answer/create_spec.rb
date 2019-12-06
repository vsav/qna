require 'rails_helper'

feature 'Authenticated can answer the questions', %q{
  In order to help someone from a community
  As an authenticated user
  I'd like to be able to answer the questions
}, js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer for question' do
      fill_in 'Answer text', with: 'Answer text'
      click_on 'Create answer'

      expect(page).to have_content 'Answer text'
      expect(current_path).to eq question_path(question)
    end

    scenario 'create answer with attached files' do
      fill_in 'Answer text', with: 'Answer text'

      attach_file 'Attach files?', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'

      expect(page).to have_content 'Answer text'
      expect(current_path).to eq question_path(question)
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'create answer with valid link' do
      fill_in 'Answer text', with: 'Answer text'
      fill_in 'Link name', with: 'Answer link'
      fill_in 'Url', with: 'http://google.com'
      click_on 'Create answer'
      expect(page).to have_content 'Answer text'
      expect(page).to have_link 'Answer link'
    end

    scenario 'create answer with invalid link' do
      fill_in 'Answer text', with: 'Answer text'
      fill_in 'Link name', with: 'Answer link'
      fill_in 'Url', with: 'invalid_url'
      click_on 'Create answer'
      expect(page).to have_content 'Links url must be a valid URL format'
    end

    scenario 'create answer with valid gist url' do
      fill_in 'Answer text', with: 'Answer text'
      fill_in 'Link name', with: 'Answer link'
      fill_in 'Url', with: 'https://gist.github.com/vsav/d0a264036e740851c80c313292b08899'
      click_on 'Create answer'
      expect(page).to have_content 'Answer text'
      expect(page).to have_content 'QnA test Gist'
    end

    scenario 'create answer with invalid gist url' do
      fill_in 'Answer text', with: 'Answer text'
      fill_in 'Link name', with: 'Answer link'
      fill_in 'Url', with: 'https://gist.github.com/vsav/404404'
      click_on 'Create answer'
      expect(page).to have_css '.loading-failed'
    end

    scenario 'create answer with invalid attributes' do
      fill_in 'Answer text', with: ''
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
