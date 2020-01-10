require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:user) { build(:user) }
  let(:access_token) { create(:access_token) }
  let!(:question) { build(:question, user: user) }
  let!(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions/:id/answers' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'Authorized' do

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it 'returns status 2xx' do
        expect(response).to be_successful
      end

      it_behaves_like 'Returns all items' do
        let(:resource) { question.answers }
        let(:resource_response) { json['answers'] }
      end

      it_behaves_like 'Returns all public fields' do
        let(:public_fields) { %w[id body user_id created_at updated_at] }
        let(:resource_response) { json['answers'].first }
        let(:resource) { question.answers.first }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'Authorized' do
      let!(:user) { build(:user) }
      let!(:question) { build(:question, user: user) }
      let!(:answer) { build(:answer, question: question) }
      let!(:links) { create_list(:link, 2, :valid_url, linkable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }

      before { 2.times { answer.files.attach(create_file_blob) } }
      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns status 2xx' do
        expect(response).to be_successful
      end

      it_behaves_like 'Returns all public fields' do
        let(:public_fields) { %w[id body user_id created_at updated_at] }
        let(:resource_response) { json['answer'] }
        let(:resource) { answer }
      end

      context 'Answer comments' do
        it_behaves_like 'Returns all items' do
          let(:resource_response) { json['answer']['comments'] }
          let(:resource) { comments }
        end

        it_behaves_like 'Returns all public fields' do
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource_response) { json['answer']['comments'].first }
          let(:resource) { comments.first }
        end
      end

      context 'Answer files' do
        it_behaves_like 'Returns all items' do
          let(:resource_response) { json['answer']['files'] }
          let(:resource) { answer.files }
        end

        it 'returns file url' do
          expect(json['answer']['files'].first['url']).to eq rails_blob_path(answer.files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST api/v1/questions/:id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'Authorized' do
      context 'Create answer with valid attributes' do
        let(:do_request) { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                answer: attributes_for(:answer) }, headers: headers }

        it 'save new answer to database' do
          expect { do_request }.to change(Answer, :count).by(1)
        end

        it 'returns status 2xx' do
          do_request
          expect(response).to be_successful
        end
      end

      context 'Create answer with invalid attributes' do
        let(:do_request) { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                answer: attributes_for(:answer, :invalid) }, headers: headers }

        it 'not save new question to database' do
          expect { do_request }.to_not change(Answer, :count)
        end

        it 'returns status 4xx' do
          do_request
          expect(response).to_not be_successful
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'Authorized' do
      context 'update answer with valid attributes' do
        before { patch "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token,
                 id: answer, answer: { body: 'new body' }, headers: headers } }

        it 'assigns new answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          expect(json['answer']['body']).to eq 'new body'
        end

        it 'returns status 2xx' do
          expect(response).to be_successful
        end
      end

      context 'update answer with invalid attributes' do
        before { patch "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token,
                 id: answer, answer: { body: '' }, headers: headers } }


        it 'not changes answer attributes' do
          expect(answer.body).to eq 'MyAnswerText'
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

  describe 'DELETE /api/v1/answers/:id/' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'Authorized' do
      context 'delete answer' do
        let(:do_request) { delete "/api/v1/answers/#{answer.id}",
                           params: { access_token: access_token.token, id: answer.id }, headers: headers }

        it 'deletes answer' do
          expect { do_request }.to change(Answer, :count).by(-1)
        end

        it 'returns status 2xx' do
          do_request
          expect(response).to be_successful
        end
      end
    end
  end
end
