require 'rails_helper'

feature 'Authorization with OAuth providers', %q{
In order to sign in or sign up
As a user or guest
I want to be able to sign in or sign up with my social network accounts
} do

  background { visit new_user_session_path }

  describe 'Sign in with Github' do
    scenario 'with email provided' do
      mock_auth_hash(:github, email: 'user@test.com')
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account'
    end

    scenario 'without email' do
      mock_auth_hash(:github)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Please provide your email for receive confirmation instructions'
      fill_in 'email', with: 'user@test.com'
      click_on 'Confirm'

      open_email('user@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'invalid confirmation email format' do
      mock_auth_hash(:github)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Please provide your email for receive confirmation instructions'
      fill_in 'email', with: ''
      click_on 'Confirm'
      expect(page).to have_content "Email can't be blank"
      fill_in 'email', with: 'test'
      click_on 'Confirm'
      expect(page).to have_content "Email is invalid"
      expect(page).to have_content "Email must be a valid email format"
    end
  end

  describe 'Sign in with Vkontakte' do
    scenario 'with email provided' do
      mock_auth_hash(:vkontakte, email: 'user@test.com')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account'
    end

    scenario 'without email' do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Please provide your email for receive confirmation instructions'
      fill_in 'email', with: 'user@test.com'
      click_on 'Confirm'

      open_email('user@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'invalid confirmation email format' do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Please provide your email for receive confirmation instructions'
      fill_in 'email', with: ''
      click_on 'Confirm'
      expect(page).to have_content "Email can't be blank"
      fill_in 'email', with: 'test'
      click_on 'Confirm'
      expect(page).to have_content "Email is invalid"
      expect(page).to have_content "Email must be a valid email format"
    end
  end
end
