require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answers) do
    question
    create_list(:answer, 5)
  end

  describe 'GET #index' do

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers for @question' do
      expect(assigns(:answers)).to match_array(question.answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end

