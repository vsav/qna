require 'rails_helper'

feature 'User can remove own questions/answers attachments', %q{
  In order to correct my question or answer
  As an author
  I'd like to remove my question or answer attachments
} do

  given(:user) {create(:user)}
  given(:user2) {create(:user)}
  given(:question) {create(:question, user: user)}
  given(:answer) {create(:answer, question: question, user: user)}

  describe 'Delete question attachment', js: true do

    background { question.files.attach(create_file_blob) }

    scenario 'author trying to remove attachment' do
      sign_in(user)
      visit question_path(question)
      within "#question-#{question.id}-files" do
        expect(page).to have_link 'image.jpg'
        click_on 'Remove file'
        expect(page).to_not have_link 'image.jpg'
      end
    end

    scenario 'not author trying to remove attachment' do
      sign_in(user2)
      visit question_path(question)
      within "#question-#{question.id}-files" do
        expect(page).to_not have_link 'Remove file'
      end
    end

    scenario 'Not authenticated user trying to remove attachment' do
      visit question_path(question)
      within "#question-#{question.id}-files" do
        expect(page).to_not have_link 'Remove file'
      end
    end
  end

  describe 'Delete answer attachment', js: true do

    background { answer.files.attach(create_file_blob) }

    scenario 'author trying to remove attachment' do
      sign_in(user)
      visit question_path(answer.question)
      within "#answer-#{answer.id}-files" do
        expect(page).to have_link 'image.jpg'
        click_on 'Remove file'
        expect(page).to_not have_link 'image.jpg'
      end
    end

    scenario 'not author trying to remove attachment' do
      sign_in(user2)
      visit question_path(answer.question)
      within "#answer-#{answer.id}-files" do
        expect(page).to_not have_link 'Remove file'
      end
    end

    scenario 'Not authenticated user trying to remove attachment' do
      visit question_path(answer.question)
      within "#answer-#{answer.id}-files" do
        expect(page).to_not have_link 'Remove file'
      end
    end
  end
end
