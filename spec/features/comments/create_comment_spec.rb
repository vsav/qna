require 'rails_helper'

feature 'Authenticated can create comments for the questions and answers', %q{
  In order to help someone from a community
  As an authenticated user
  I'd like to be able to leave comments for the questions and answers
}, js: true do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'user can create comment for question and answer and it will be available in another user browser' do
      using_session('guest') do
        visit question_path(question)
        expect(page).to have_no_content 'Question Comment text'
        expect(page).to have_no_content 'Answer Comment text'
      end
      using_session('user') do
        sign_in(user)
        visit question_path(question)

        within "#question-#{question.id}" do
          click_on 'Leave comment'
          expect(page).to have_css("#new-question-#{question.id}-comment")
          fill_in 'comment[body]', with: 'Question Comment text'
          click_on 'Create comment'

          within "#question-#{question.id}-comments" do
            expect(page).to have_content 'Question Comment text'
          end
        end

        within "#answer-#{answer.id}" do
          click_on 'Leave comment'
          expect(page).to have_css("#new-answer-#{answer.id}-comment")
          fill_in 'comment[body]', with: 'Answer Comment text'
          click_on 'Create comment'

          within "#answer-#{answer.id}-comments" do
            expect(page).to have_content 'Answer Comment text'
          end
        end
      end

      using_session('guest') do
        expect(page).to have_content 'Answer Comment text'
      end

    end

    scenario 'if comment have errors it will not appear on page and other browser' do
      using_session('guest') do
        visit question_path(question)
        expect(page).to_not have_css '.comment'
      end
      using_session('user') do
        sign_in(user)
        visit question_path(question)
        within "#answer-#{answer.id}" do
          click_on 'Leave comment'
          expect(page).to have_css("#new-answer-#{answer.id}-comment")
          click_on 'Create comment'
          expect(page).to have_content "Body can't be blank"
        end
        within "#question-#{question.id}" do
          click_on 'Leave comment'
          expect(page).to have_css("#new-question-#{question.id}-comment")
          click_on 'Create comment'
          expect(page).to have_content "Body can't be blank"
        end
      end
      using_session('guest') do
        within "#answer-#{answer.id}" do
          expect(page).to_not have_css '.comment'
        end
        within "#question-#{question.id}" do
          expect(page).to_not have_css '.comment'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'create comment' do
      visit question_path(question)
      expect(page).to have_content 'You need to sign in or sign up to answer the questions'
      expect(page).to_not have_link 'Create comment'
    end
  end

end
