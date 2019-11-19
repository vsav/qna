require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) { 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Ruby_On_Rails_Logo.svg/1200px-Ruby_On_Rails_Logo.svg.png' }

  scenario 'User add link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My pic'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My pic', href: url
  end
end
