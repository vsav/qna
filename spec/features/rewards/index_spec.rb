require 'rails_helper'

feature 'User can view own rewards' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:reward) { create(:reward, user: user) }
  given!(:reward2) { create(:reward, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'can see his rewards and can not see other user rewards' do
      click_on 'View rewards'
      expect(page).to have_content reward.title
      expect(page).to have_content reward.question.title
      expect(page).to_not have_content reward2.title
    end
  end

  describe 'Unauthenticated user' do
    scenario 'do not have view rewards link' do
      visit root_path
      expect(page).to_not have_link 'View rewards'
    end

    scenario 'can not see other user rewards' do
      visit user_rewards_path(user)
      expect(page).to_not have_selector('.rewards')
    end
  end
end
