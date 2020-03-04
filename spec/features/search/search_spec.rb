# frozen_string_literal: true

require 'rails_helper'

feature 'User can search', "
  In order to search for specified information
  I'd like to be able to get search results
", sphinx: true, js: true do
  given!(:user2) { create(:user) }
  given!(:user) { create(:user, email: 'user-test@test.com') }
  given!(:question) { create(:question, body: 'question-test', user: user2) }
  given!(:answer) { create(:answer, body: 'answer-test', user: user2) }
  given!(:comment) { create(:comment, body: 'comment-test', commentable: question, user: user2) }
  describe 'User can search in specified resource' do
    before { visit root_path }

    SearchService::RESOURCES.each do |resource|
      scenario "#{resource} search" do
        other_resources = SearchService::RESOURCES.reject { |other| other == resource }
        ThinkingSphinx::Test.run do
          within '.search-form' do
            fill_in :query, with: 'test'
            select resource, from: :resource
            click_on 'Search'
          end

          expect(page).to have_content "Search results for 'test':"
          within '.search-results' do
            expect(page).to have_content "#{resource.downcase}-test"
            other_resources.each do |other|
              expect(page).to_not have_content "#{other.downcase}-test"
            end
          end
        end
      end
    end

    scenario 'Search entire site' do
      ThinkingSphinx::Test.run do
        within '.search-form' do
          select 'Entire site', from: :resource
          fill_in :query, with: 'test'
          click_on 'Search'
        end

        expect(page).to have_content "Search results for 'test':"
        within '.search-results' do
          expect(page).to have_content question.body
          expect(page).to have_content answer.body
          expect(page).to have_content comment.body
          expect(page).to have_content user.email
        end
      end
    end

    scenario 'Search unexisted word' do
      ThinkingSphinx::Test.run do
        within '.search-form' do
          select 'Entire site', from: :resource
          fill_in :query, with: 'zzz'
          click_on 'Search'
        end

        expect(page).to have_content "Search results for 'zzz':"
        within '.search-results' do
          expect(page).to have_content 'Nothing found'
        end
      end
    end
  end
end
