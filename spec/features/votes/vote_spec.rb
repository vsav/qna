# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for votable', "
   As an authenticated user and as not votable author
   I'd like to be able to vote for votable resource
 " do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question1) { create(:question, user: user1) }
  given(:question2) { create(:question, user: user2) }
  given!(:answer1) { create(:answer, question: question1, user: user1) }
  given!(:answer2) { create(:answer, question: question2, user: user2) }

  describe 'Authenticated user', js: true do
    before { sign_in(user1) }

    scenario 'like another user resource' do
      visit question_path(question2)

      within "#question-#{question2.id}" do
        click_on 'like'
        expect(page).to have_content 'Rating: 1'
      end

      within "#answer-#{answer2.id}" do
        click_on 'like'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'like own resource' do
      visit question_path(question1)

      within "#question-#{question1.id}-rating" do
        expect(page).to have_css 'a.vote-button.like-button.disabled'
      end

      within "#answer-#{answer1.id}-rating" do
        expect(page).to have_css 'a.vote-button.like-button.disabled'
      end
    end

    scenario 'dislike other users resource' do
      visit question_path(question2)

      within "#question-#{question2.id}" do
        click_on 'dislike'
        expect(page).to have_content 'Rating: -1'
      end

      within "#answer-#{answer2.id}" do
        click_on 'dislike'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'dislike own resource' do
      visit question_path(question1)

      within "#question-#{question1.id}-rating" do
        expect(page).to have_css 'a.vote-button.dislike-button.disabled'
      end

      within "#answer-#{answer1.id}-rating" do
        expect(page).to have_css 'a.vote-button.dislike-button.disabled'
      end
    end

    scenario 'unvote and revote other users resource' do
      visit question_path(question2)

      within "#question-#{question2.id}" do
        click_on 'like'
        expect(page).to have_content 'Rating: 1'
        click_on 'unvote'
        expect(page).to have_content 'Rating: 0'
        click_on 'dislike'
        expect(page).to have_content 'Rating: -1'
      end

      within "#answer-#{answer2.id}" do
        click_on 'like'
        expect(page).to have_content 'Rating: 1'
        click_on 'unvote'
        expect(page).to have_content 'Rating: 0'
        click_on 'dislike'
        expect(page).to have_content 'Rating: -1'
      end
    end
  end
end
