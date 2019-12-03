require 'rails_helper'

RSpec.shared_examples_for Voted do

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }
  let(:votable) do
    if model.to_s == 'Answer'
      question = create(:question, user: user2)
      create(:answer, question: question, user: user2)
    else
      create(:question, user: user2)
    end
  end


  describe 'POST #like' do
    context 'Authenticated user' do

      before do
        sign_in(user1)
      end

      it 'tries to like other user question' do
        expect { post :like, params: { id: votable }, format: :json }.to change(votable, :total_rating).by(1)
      end

      it 'renders valid json on like' do
        post :like, params: { id: votable }, format: :json
        rendered_json = {
          total_rating: votable.total_rating,
          klass: votable.class.to_s.downcase,
          votable_id: votable.id
        }.to_json

        expect(response.body).to eq(rendered_json)
      end

      it 'tries to like other user question more than once' do
        post :like, params: { id: votable }, format: :json
        expect { post :like, params: { id: votable }, format: :json }.to_not change(votable, :total_rating)
      end

      it 'tries to like own question' do
        sign_in(user2)
        expect { post :like, params: { id: votable }, format: :json }.to_not change(votable, :total_rating)
        expect(response).to have_http_status 403
      end
    end

    context 'Unauthenticated user' do
      it 'tries to like question' do
        expect { post :like, params: { id: votable }, format: :json }.to_not change(votable, :total_rating)
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'POST #dislike' do
    context 'Authenticated user' do

      before { sign_in(user) }

      it 'tries to dislike other user question' do
        expect { post :dislike, params: { id: votable }, format: :json }.to change(votable, :total_rating).by(-1)
      end

      it 'renders valid json on dislike' do
        post :dislike, params: { id: votable }, format: :json
        rendered_json = {
            total_rating: votable.total_rating,
            klass: votable.class.to_s.downcase,
            votable_id: votable.id
        }.to_json

        expect(response.body).to eq(rendered_json)
      end

      it 'tries to dislike other user question more than once' do
        post :dislike, params: { id: votable }, format: :json
        expect { post :dislike, params: { id: votable }, format: :json }.to_not change(votable, :total_rating)
      end

      it 'tries to like own question' do
        sign_in(user2)
        expect { post :dislike, params: { id: votable }, format: :json }.to_not change(votable, :total_rating)
        expect(response).to have_http_status 403
      end
    end

    context 'Unauthenticated user' do
      it 'tries to dislike question' do
        expect { post :dislike, params: { id: votable }, format: :json }.to_not change(votable, :total_rating)
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'DELETE #unvote' do
    context 'Authenticated user' do

      before { sign_in(user1) }

      it 'tries to recall his vote (unvote)' do
        post :like, params: { id: votable }, format: :json
        expect { delete :unvote, params: { id: votable }, format: :json }.to change(votable, :total_rating).by(-1)
      end

      it 'renders valid json on unvote' do
        post :dislike, params: { id: votable }, format: :json
        delete :unvote, params: { id: votable }, format: :json
        rendered_json = {
            total_rating: votable.total_rating,
            klass: votable.class.to_s.downcase,
            votable_id: votable.id
        }.to_json

        expect(response.body).to eq(rendered_json)
      end

      it 'tries to recall other user vote' do
        post :like, params: { id: votable }, format: :json
        set_session do
          sign_in(user2)
          expect { delete :unvote, params: { id: votable }, format: :json }.to_not change(votable, :total_rating)
          expect(response).to have_http_status 403
        end
      end
    end
    context 'Unauthenticated user' do
      it 'tries to dislike question' do
        expect { post :dislike, params: { id: votable }, format: :json }.to_not change(votable, :total_rating)
        expect(response).to have_http_status 401
      end
    end
  end
end
