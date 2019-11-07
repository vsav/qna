require 'rails_helper'

feature 'User can mark answer for own question as best', %q{
  In order to choose the best answer for my question
  As a question's author
  I'd like to be able to mark answer as best
}, js: true do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user, best: true) }
  given!(:answer3) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do

    scenario 'answers have link to mark them best and best answer have not' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(answer1.best).to be_falsey
        expect(answer2.best).to be_truthy
        expect(answer3.best).to be_falsey
        expect(page).to have_link(href: "/answers/#{answer1.id}/set_best")
        expect(page).to_not have_link(href: "/answers/#{answer2.id}/set_best")
        expect(page).to have_link(href: "/answers/#{answer3.id}/set_best")
      end
    end

    scenario 'best answer renders on top' do
      sign_in(user)
      visit question_path(question)
      top_answer = question.answers.first
      expect(top_answer.best).to be_truthy
      expect(page).to have_link(href: "/answers/#{answer3.id}/set_best")
      find("a[href = '/answers/#{answer3.id}/set_best']").click
      visit question_path(question)
      expect(top_answer).to_not eq(question.answers.first)
      expect(answer3).to eq(question.answers.first)
    end

    scenario 'author trying to mark answer as best' do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answer1.id}" do
        expect(page).to have_link(href: "/answers/#{answer1.id}/set_best")
        find("a[href = '/answers/#{answer1.id}/set_best']").click
        sleep 1 #wait_for_ajax не работает...
        answer1.reload
        expect(answer1.best).to be_truthy
        expect(page).to_not have_link(href: "/answers/#{answer1.id}/set_best")
      end

      within "#answer-#{answer2.id}" do
        answer2.reload
        expect(page).to have_link(href: "/answers/#{answer2.id}/set_best")
        expect(answer2.best).to be_falsey
      end
    end

    scenario 'non-author trying to mark answer as best' do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link(href: /"\bMark as best"/)
    end

    scenario 'guest trying to mark answer as best' do
      visit question_path(question)
      expect(page).to_not have_link(href: /"\bMark as best"/)
    end

  end
end
