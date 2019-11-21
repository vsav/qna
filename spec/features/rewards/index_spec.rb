require 'rails_helper'

feature 'User can view own rewards' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:reward) { create(:reward, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'can see his rewards' do
      click_on 'View rewards'
      expect(page).to have_content reward.title
      expect(page).to have_content reward.question.title
    end

    scenario 'can not see other user rewards' do
      reward.update(user: user2)
      click_on 'View rewards'
      expect(page).to have_no_content reward.title
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
