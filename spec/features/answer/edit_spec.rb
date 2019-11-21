require 'rails_helper'
feature 'Edit answer', %q{
  In order to edit my answer
  As an answer author
  I'd like to be able to edit answer
}, js: true do
  given(:user) {create(:user) }
  given(:user2) {create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'edit own answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      within '.answers' do
        expect(page).to have_field('Body', with: answer.body)
        fill_in 'Body', with: 'Another text'
        click_on 'Save'
        expect(page).to have_content 'Another text'
        expect(page).to_not have_field 'Body'
      end
      expect(page).to have_content 'Answer was successfully updated.'
    end

    scenario 'edit own answer with invalid params' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      within '.answers' do
        expect(page).to have_field('Body', with: answer.body)
        fill_in 'Body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'author trying to attach files to own answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within "#edit-answer-#{answer.id}" do
        expect(page).to have_field 'answer_files'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'author trying to attach links to own answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      within "#edit-answer-#{answer.id}" do
        click_on 'add link'
        fill_in 'Link name', with: 'Answer link'
        fill_in 'Url', with: 'http://google.com'
        click_on 'Save'
      end
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Answer link'
      end
    end

    scenario 'author trying to attach invalid links to own answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      within "#edit-answer-#{answer.id}" do
        click_on 'add link'
        fill_in 'Link name', with: 'Answer link'
        fill_in 'Url', with: 'invalid'
        click_on 'Save'
      end
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Links url must be a valid URL format'
      end
    end

    scenario 'author trying to attach gist link to own answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within "#edit-answer-#{answer.id}" do
        click_on 'add link'
        fill_in 'Link name', with: 'Answer link'
        fill_in 'Url', with: 'https://gist.github.com/vsav/d0a264036e740851c80c313292b08899'
        click_on 'Save'
      end
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'QnA test Gist'
      end
    end

    scenario 'author trying to attach gist link to own answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within "#edit-answer-#{answer.id}" do
        click_on 'add link'
        fill_in 'Link name', with: 'Answer link'
        fill_in 'Url', with: 'https://gist.github.com/vsav/404404'
        click_on 'Save'
      end
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'URL not found'
      end
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
