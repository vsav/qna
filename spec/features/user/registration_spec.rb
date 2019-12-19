require 'rails_helper'

feature 'Guest can register', %q{
  In order to sign in
  As a guest
  I'd like to be able to register
} do

  let(:user) { create(:user) }

  before { visit new_user_registration_path }

  scenario 'Guest trying to register' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: 'secret'
    fill_in 'Password confirmation', with: 'secret'
    click_on 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    open_email('user@test.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'Guest trying to register with invalid data' do
    fill_in 'Email', with: ''
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'Guest trying to register with taken email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'secret'
    fill_in 'Password confirmation', with: 'secret'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
