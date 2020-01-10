require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:questions) { create_list(:question, 2, user: user) }
  let(:question) { questions.first }

  describe 'GET /api/v1/questions' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'Authorized' do

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns status 2xx' do
        expect(response).to be_successful
      end

      it_behaves_like 'Returns all items' do
        let(:resource) { questions }
        let(:resource_response) { json['questions'] }
      end

      it_behaves_like 'Returns all public fields' do
        let(:public_fields) { %w[id title body user_id created_at updated_at] }
        let(:resource_response) { json['questions'].first }
        let(:resource) { question }
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'Authorized' do
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }
      let!(:links) { create_list(:link, 2, :valid_url, linkable: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }

      before { 2.times { question.files.attach(create_file_blob) } }
      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns status 2xx' do
        expect(response).to be_successful
      end

      it_behaves_like 'Returns all public fields' do
        let(:public_fields) { %w[id title body user_id created_at updated_at] }
        let(:resource_response) { json['question'] }
        let(:resource) { question }
      end

      context 'Answers' do
        it_behaves_like 'Returns all items' do
          let(:resource_response) { json['question']['answers'] }
          let(:resource) { answers }
        end

        it_behaves_like 'Returns all public fields' do
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource_response) { json['question']['answers'].first }
          let(:resource) { answers.first }
        end
      end

      context 'Question comments' do
        it_behaves_like 'Returns all items' do
          let(:resource_response) { json['question']['comments'] }
          let(:resource) { comments }
        end

        it_behaves_like 'Returns all public fields' do
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource_response) { json['question']['comments'].first }
          let(:resource) { comments.first }
        end
      end

      context 'Question files' do
        it_behaves_like 'Returns all items' do
          let(:resource_response) { json['question']['files'] }
          let(:resource) { question.files }
        end

        it 'returns file url' do
          expect(json['question']['files'].first['url']).to eq rails_blob_path(question.files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'Authorized' do
      context 'Create question with valid attributes' do
        let(:do_request) { post '/api/v1/questions/', params: { access_token: access_token.token,
                           question: attributes_for(:question) }, headers: headers }

        it 'save new question to database' do
          expect { do_request }.to change(Question, :count).by(1)
        end

        it 'returns status 2xx' do
          do_request
          expect(response).to be_successful
        end
      end

      context 'Create question with invalid attributes' do
        let(:do_request) { post '/api/v1/questions/', params: { access_token: access_token.token,
                           question: attributes_for(:question, :invalid) }, headers: headers }

        it 'not save new question to database' do
          expect { do_request }.to_not change(Question, :count)
        end

        it 'returns status 4xx' do
          do_request
          expect(response).to_not be_successful
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'Authorized' do
      context 'update question with valid attributes' do
        before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token,
                 id: question, question: { title: 'new title', body: 'new body' }, headers: headers } }

        it 'assigns new question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          expect(json['question']['title']).to eq 'new title'
          expect(json['question']['body']).to eq 'new body'
        end

        it 'returns status 2xx' do
          expect(response).to be_successful
        end
      end

      context 'update question with invalid attributes' do
        before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token,
                 id: question, question: { title: '', body: '' }, headers: headers } }


        it 'not changes question attributes' do
          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 'returns status 4xx' do
          expect(response).to_not be_successful
        end

        it 'returns validation errors' do
          expect(json['errors'].to_s).to include("can't be blank")
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'Authorized' do
      context 'delete question' do
        let(:do_request) { delete "/api/v1/questions/#{question.id}",
                           params: { access_token: access_token.token, id: question.id }, headers: headers }

        it 'deletes question' do
          expect { do_request }.to change(Question, :count).by(-1)
        end

        it 'returns status 2xx' do
          do_request
          expect(response).to be_successful
        end
      end
    end
  end
end
