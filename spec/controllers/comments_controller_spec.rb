require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    before { login(user) }

    describe '#POST create comment for question' do
      context 'with valid attributes' do
        it 'saves a new comment to the database' do

          expect {
            post :create, params: { comment: attributes_for(:comment), question_id: question.id, user: user }, format: :js
          }.to change(question.comments, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { comment: attributes_for(:comment), question_id: question.id, user: user }, format: :js
          expect(response).to render_template :create
        end

        it 'assigns new comment to current_user' do
          post :create, params: { comment: attributes_for(:comment), question_id: question.id, user: user }, format: :js
          expect(assigns(:comment).user).to eq user
        end

        it 'starts broadcast to CommentsChannel' do

          expect {
            post :create, params: { comment: attributes_for(:comment), question_id: question.id, user: user }, format: :js
          }.to have_broadcasted_to("questions/#{question.id}/comments")
        end
      end

      context 'with invalid attributes' do
        it 'do not saves a new comment to the database' do
          expect {
            post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id, user: user }, format: :js
          }.to_not change(question.comments, :count)
        end

        it 'renders create' do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id, user: user }, format: :js

          expect(response).to render_template :create
        end

        it 'do not starts broadcast to CommentsChannel' do

          expect {
            post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id, user: user }, format: :js
          }.to_not have_broadcasted_to("questions/#{question.id}/comments")
        end

      end
    end

    describe '#POST create comment for answer' do
      context 'with valid attributes' do
        it 'saves a new comment to the database' do

          expect {
            post :create, params: { comment: attributes_for(:comment), question: question, answer_id: answer.id, user: user }, format: :js
          }.to change(answer.comments, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { comment: attributes_for(:comment), question: question, answer_id: answer.id, user: user }, format: :js

          expect(response).to render_template :create
        end

        it 'assigns new comment to current_user' do
          post :create, params: { comment: attributes_for(:comment), question: question, answer_id: answer.id, user: user }, format: :js

          expect(assigns(:comment).user).to eq user
        end

        it 'starts broadcast to CommentsChannel' do

          expect {
            post :create, params: { comment: attributes_for(:comment), question: question, answer_id: answer.id, user: user }, format: :js
          }.to have_broadcasted_to("questions/#{answer.question_id}/comments")
        end
      end

      context 'with invalid attributes' do
        it 'do not saves a new comment to the database' do
          expect {
            post :create, params: { comment: attributes_for(:comment, :invalid), question: question, answer_id: answer.id, user: user }, format: :js
          }.to_not change(answer.comments, :count)
        end

        it 'renders create' do
          post :create, params: { comment: attributes_for(:comment, :invalid), question: question, answer_id: answer.id, user: user }, format: :js

          expect(response).to render_template :create
        end
        it 'do not starts broadcast to CommentsChannel' do
          expect {
            post :create, params: { comment: attributes_for(:comment, :invalid), question: question, answer_id: answer.id, user: user }, format: :js
          }.to_not have_broadcasted_to("questions/#{question.id}/comments")
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    context 'tries to create comment for question' do
      it 'do not saves a new comment to the database' do
        expect {
          post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :js
        }.to_not change(question.comments, :count)
      end

      it 'do not starts broadcast to CommentsChannel' do
        expect {
          post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :js
        }.to_not have_broadcasted_to("questions/#{question.id}/comments")
      end
    end

    context 'tries to create comment for answer' do
      it 'do not saves a new comment to the database' do
        expect {
          post :create, params: { comment: attributes_for(:comment), question: question, answer_id: answer.id }, format: :js
        }.to_not change(answer.comments, :count)
      end

      it 'do not starts broadcast to CommentsChannel' do
        expect {
          post :create, params: { comment: attributes_for(:comment), question: question, answer_id: answer.id }, format: :js
        }.to_not have_broadcasted_to("questions/#{answer.question_id}/comments")
      end

    end
  end
end
