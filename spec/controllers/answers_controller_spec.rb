require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do

    context 'with valid attributes' do
      before { sign_in(user) }
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
      before { sign_in(user) }
      it 'does not save the answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end

    context 'POST #create as guest' do

      it 'redirects to sign_in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not save the answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do

    context 'as author with valid attributes' do
      before { sign_in(user) }
      it 'assigns the requested answer to @answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to question for updated answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'as author with invalid attributes' do

      before do
        sign_in(user)
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }
      end

      it 'does not change answer' do
        answer.reload
        expect(answer.body).to eq 'MyAnswerText'
        expect(flash[:alert]).to match('Answer was not updated')
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'as not author with valid attributes' do

      before do
        sign_in(user2)
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }
      end

      it 'not changes answer attributes' do
        answer.reload
        expect(answer.body).to_not eq 'new body'
        expect(flash[:alert]).to match('Answer was not updated')
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'as guest' do

      before { patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } } }

      it 'redirects to sign_in page' do
        expect(response).to redirect_to new_user_session_path
      end

      it 'not changes answer attributes' do
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    context 'as author' do
      before { sign_in(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'as not author' do
      before { sign_in(user2) }

      it 'do not deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
        expect(flash[:alert]).to match('You do not have permission to do that')
      end

      it 're-renders question page' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to render_template 'questions/show'
      end
    end

    context 'as guest' do

      it 'redirects to sign_in page' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to new_user_session_path
      end

      it 'do not deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
      end
    end
  end
end

