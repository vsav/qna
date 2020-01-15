require 'rails_helper'

feature 'User can search', %q{
  In order to search for specified information
  I'd like to be able to get search results
}, sphinx: true, js: true do

  given!(:user) { create(:user, email: 'user-test@test.com') }
  given!(:question) { create(:question, body: 'question-test', user: user) }
  given!(:answer) { create(:answer, body: 'answer-test', user: user) }
  given!(:comment) { create(:comment, body: 'comment-test', commentable: question, user: user) }

  describe 'User can search in specified resource' do

    before { visit root_path }

    SearchService::RESOURCES.each do |resource|
      scenario "#{resource} search" do
        ThinkingSphinx::Test.run do
          within '.search-form' do
            fill_in :query, with: 'test'
            select resource, from: :resource
            click_on 'Search'
          end

          expect(page).to have_content "Search results for 'test':"
          within '.search-results' do
            expect(page).to have_content "#{resource.downcase}-test"
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
