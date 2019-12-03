require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  it_behaves_like Voted

  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do

    context 'with valid attributes' do
      before { sign_in(user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'belongs to user and belongs to question' do
        post :create, params: { question_id: question, user: user, answer: attributes_for(:answer), format: :js }
        answer = Answer.order(created_at: :desc).first
        expect(answer.question).to eq question
        expect(answer.user).to eq user
      end

      it 'saves a new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) },
                      format: :js }.to change(Answer, :count).by(1)
      end

      it 'saves a new answer with links to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer),
                                         link: create(:link, :valid_url, linkable: answer) },
                                         format: :js }.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { sign_in(user) }
      it 'does not save the answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) },
                      format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
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
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'adds links to answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer),
                               link: create(:link, :valid_url, linkable: answer)  }, format: :js
        answer.reload
        expect(answer.links.first.name).to eq 'MyString'
        expect(answer.links.first.url).to eq 'http://example.com'
      end

      it 'renders update view' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js }
        expect(response).to render_template :update
      end


    end

    context 'as author with invalid attributes' do

      before do
        sign_in(user)
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid), format: :js }
      end

      it 'does not change answer' do
        answer.reload
        expect(answer.body).to eq 'MyAnswerText'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'as not author with valid attributes' do

      before do
        sign_in(user2)
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js }
      end

      it 'not changes answer attributes' do
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it 'renders redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'as guest' do

      before { patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js }

      it 'returns status 401: unauthorized' do
        expect(response).to have_http_status(401)
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
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'as not author' do
      before { sign_in(user2) }

      it 'do not deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to root path' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(response).to redirect_to root_path
      end
    end

    context 'as guest' do

      it 'returns status 401: unauthorized' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(response).to have_http_status(401)
      end

      it 'do not deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #best' do
    let!(:answer1) { create(:answer, question: question, user: user, best: true) }
    let!(:answer2) { create(:answer, question: question, user: user) }
    context 'as author' do
      before do
        sign_in(user)
        patch :set_best, params: { id: answer2, format: :js }
      end

      it 'marks answer as best' do
        answer2.reload
        expect(answer2).to be_best
      end

      it 'unmarks previous best ' do
        answer1.reload
        expect(answer1).to_not be_best
      end

      it 'renders set_best' do
        expect(response).to render_template :set_best
      end

    end

    context 'as not author' do
      before do
        sign_in(user2)
        patch :set_best, params: { id: answer2, format: :js }
      end

      it 'do not marks answer as best' do
        answer2.reload
        expect(answer2).to_not be_best
      end

      it 'do not unmarks previous best' do
        answer1.reload
        expect(answer1).to be_best
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'as guest' do

      it 'returns status 401: unauthorized' do
        patch :set_best, params: { id: answer2, format: :js }
        expect(response).to have_http_status(401)
      end

      it 'do not marks answer as best' do
        answer2.reload
        expect(answer2).to_not be_best
      end

      it 'do not unmarks previous best' do
        answer1.reload
        expect(answer1).to be_best
      end

    end
  end
end

