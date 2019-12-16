require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Question text', with: 'text text text'
      click_on 'Ask question'
      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do

      fill_in 'Question title', with: ''
      fill_in 'Question text', with: 'text text text'
      click_on 'Ask question'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Question text', with: 'text text text'

      attach_file 'Attach files?', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'create question with valid link' do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Question text', with: 'Question text'
      fill_in 'Link name', with: 'Question link'
      fill_in 'Url', with: 'http://google.com'
      click_on 'Ask question'
      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_link 'Question link'
    end

    scenario 'create question with invalid link' do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Question text', with: 'Question text'
      fill_in 'Link name', with: 'Question link'
      fill_in 'Url', with: 'invalid_url'
      click_on 'Ask question'
      expect(page).to have_content 'Links url must be a valid URL format'
    end

    scenario 'create question with valid gist url', js: true do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Question text', with: 'Question text'
      fill_in 'Link name', with: 'Question link'
      fill_in 'Url', with: 'https://gist.github.com/vsav/d0a264036e740851c80c313292b08899'
      click_on 'Ask question'
      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content 'QnA test Gist'
    end

    scenario 'create question with invalid gist url', js: true do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Question text', with: 'Question text'
      fill_in 'Link name', with: 'Question link'
      fill_in 'Url', with: 'https://gist.github.com/vsav/404404'
      click_on 'Ask question'
      expect(page).to have_css '.loading-failed'
    end

    scenario 'asks a question with reward' do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Question text', with: 'text text text'
      fill_in 'Reward title', with: 'Reward for best answer'
      attach_file 'Attach reward image?', "#{Rails.root}/spec/fixtures/files/image.jpg"
      click_on 'Ask question'
      expect(page).to have_content 'Reward for best answer'
      expect(page.find('.reward_image')['src']).to have_content 'image.jpg'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    expect(page).to have_content 'You need to sign in or sign up to ask questions'
    expect(page).to_not have_link 'Ask question'
  end

  describe 'Questions in multiple browsers' do
    scenario 'user can create question and it will be available in another user browser', js: true do
      using_session('guest') do
        visit questions_path
        expect(page).to have_no_content 'ActionCable Question'
      end
      using_session('user') do
        sign_in(user)
        visit questions_path

        click_on 'Ask question'

        fill_in 'Question title', with: 'ActionCable Question'
        fill_in 'Question text', with: 'text text text'
        click_on 'Ask question'

        expect(page).to have_content 'ActionCable Question'
        expect(page).to have_content 'text text text'

      end
      using_session('guest') do
        expect(page).to have_content 'ActionCable Question'
      end
    end

    scenario 'if question have errors it will not appear on page and other browser' do
      using_session('guest') do
        visit questions_path
        expect(page).to have_no_content '.question-header'
      end
      using_session('user') do
        sign_in(user)
        visit questions_path
        expect(page).to have_no_content '.question-header'

        click_on 'Ask question'
        fill_in 'Question title', with: ''
        fill_in 'Question text', with: ''
        click_on 'Ask question'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"

      end
      using_session('guest') do
        expect(page).to_not have_content '.question-header'
      end
    end
  end
end
