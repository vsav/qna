require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do

      it 'belongs to user and belongs to question' do
        post :create, params: { question_id: question, user: user, answer: attributes_for(:answer) }
        answer = Answer.all.order(created_at: :desc).first
        expect(answer.question).to eq question
        expect(answer.user).to eq user
      end

      it 'saves a new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do

      it 'does not save the answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'POST #create as guest' do
    it 'redirects to sign_in page' do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH #update as author' do
    before { sign_in(user) }
    context 'with valid attributes' do

      it 'assigns the requested answer to @answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_answer_path(answer)
      end
    end

    context 'with invalid attributes' do

      before { patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload
        expect(answer.body).to eq 'MyAnswerText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH #update as not author' do
    context 'with valid attributes' do
      it 'not changes answer attributes' do
        user2 = create(:user)
        sign_in(user2)
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to_not eq 'new body'
        expect(flash[:alert]).to match('Answer was not updated')
      end
    end
  end

  describe 'PATCH #update as guest' do
    it 'redirects to sign_in page' do
      patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'DELETE #destroy as author' do
    before { sign_in(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to question_answers_path
    end
  end

  describe 'DELETE #destroy as not author' do
    let(:user2) { create(:user) }
    let!(:answer) { create(:answer, user: user2) }

    it 'do not deletes the answer' do
      sign_in(user)
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(0)
      expect(flash[:alert]).to match('You do not have permission to do that')
    end
  end

  describe 'DELETE #destroy as guest' do
    it 'redirects to sign_in page' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to new_user_session_path
    end
  end
end

