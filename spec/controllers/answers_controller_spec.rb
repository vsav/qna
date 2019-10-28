require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:user) { create(:user) }
  let(:author) { create(:user) }

=begin
  describe 'GET #index' do
    let(:answers) do
      question
      create_list(:answer, 5)
    end

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers for @question' do
      expect(assigns(:answers)).to match_array(question.answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: answer, question_id: question } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { get :new, params: { question_id: question} }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
=end

=begin
  describe 'GET #edit' do

    before { get :edit, params: { id: answer, question_id: question } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end
=end

  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do

      it 'checks the question for which answer is being created' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        answer = Answer.all.order(created_at: :desc).first
        expect(answer.question).to eq question
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

  describe 'PATCH #update as author' do
    before { sign_in(author) }
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

      it 'redirects to updated question' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_answer_path(answer)
      end
    end

    context 'with invalid attributes' do

      before { patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(author) }
    let!(:answer) { create(:answer) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to question_answers_path
    end
  end
end

