require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do

    before do
      sign_in(user)
      question.files.attach(create_file_blob)
    end

    context 'As author' do

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end

    end

    context 'As not author' do

      before { sign_in(user2) }

      it 'do not deletes attachment' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'As guest' do

      before { sign_out(user) }

      it 'do not deletes attachment' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'returns 401 status' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end


end
