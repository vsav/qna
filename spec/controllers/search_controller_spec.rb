require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #results' do
    SearchService::RESOURCES.each do |resource|
      it "search in #{resource}" do
        expect(resource.constantize).to receive(:search).with('test')
        get :results, params: { input: 'test', resource: resource }
      end

      it 'renders results view' do
        expect(resource.constantize).to receive(:search).with('test')
        get :results, params: { input: 'test', resource: resource }
        expect(response).to render_template :results
      end

    end

    it 'search entire site' do
      expect(ThinkingSphinx).to receive(:search).with('test')
      get :results, params: { input: 'test' }
    end
  end
end
