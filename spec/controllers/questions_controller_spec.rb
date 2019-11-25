require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }


  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns links to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do

      before { login(user) }
      let!(:question) { create(:question, user: user) }
      it 'saves a new question to database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'saves a new question with links to database' do
        expect { post :create, params: { question: attributes_for(:question), link: create(:link, :valid_url, linkable: question) },
                      format: :js }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'question belongs to user' do
        post :create, params: { question: attributes_for(:question) }
        question = Question.order(created_at: :desc).first
        expect(question.user).to eq user
      end
    end

    context 'with invalid attributes' do

      before { login(user) }

      it 'does not save the question to database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    context 'as guest' do

      it 'redirects to sign_in page' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not save the question to database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end
    end
  end


  describe 'PATCH #update' do

    context 'as author with valid attributes' do
      before { login(user) }

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'adds links to question' do
        patch :update, params: { id: question, question: attributes_for(:question),
                                 link: create(:link, :valid_url, linkable: question)  }, format: :js
        question.reload
        expect(question.links.first.name).to eq 'MyString'
        expect(question.links.first.url).to eq 'http://example.com'
      end

      it 'renders question update view' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'as author with invalid attributes' do
      before do
        login(user)
        patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
      end

      it 'does not change question' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'renders question update view' do
        expect(response).to render_template :update
      end
    end

    context 'as not author with valid attributes' do

      before do
        login(user2)
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
      end

      it 'not changes question attributes' do
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'as guest' do

      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js } }

      it 'redirects to sign_in page' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end

      it 'not changes question attributes' do
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context  'as author' do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'as not author' do
      before { login(user2) }

      it 'do not deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        expect(flash[:alert]).to match('You do not have permission to do that')
      end

      it 're-renders show view' do
        delete :destroy, params: { id: question }
        expect(response).to render_template :show
      end
    end

    context 'as guest' do

      it 'redirects to sign_in page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end

      it 'do not deletes the answer' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
