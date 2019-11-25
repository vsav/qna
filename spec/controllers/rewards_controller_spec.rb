require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:rewards) { create_list(:reward, 2, question: question, user: user) }

  describe 'GET #index' do
    context 'authenticated user' do
      before do
        login(user)
        get :index, params: { user_id: user.id }
      end


      it 'populates an array with user rewards' do
        expect(assigns(:rewards)).to match_array(rewards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'unauthenticated user' do
      before { get :index, params: { user_id: user.id } }

      it 'do not populate an array with user rewards' do
        expect(assigns(:badges)).to be_nil
      end

      it 'redirects to login page' do
        expect(response).to redirect_to(new_user_session_path)
      end

    end
  end
end
