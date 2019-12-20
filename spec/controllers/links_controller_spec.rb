require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link1) { create(:link, :valid_url, linkable: question) }

  describe 'DELETE #destroy' do

    context 'As author' do

      before { sign_in(user) }

      it 'deletes link' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to render_template :destroy
      end

    end

    context 'As not author' do

      before { sign_in(user2) }

      it 'do not deletes link' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(question.links, :count)
      end

      it 'returns 403 status' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to have_http_status(403)
      end
    end

    context 'As guest' do

      it 'do not deletes link' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(question.links, :count)
      end

      it 'returns 401 status' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
