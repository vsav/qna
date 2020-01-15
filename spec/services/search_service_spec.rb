require 'rails_helper'

RSpec.describe SearchService do
  it 'calls entire site search when resource empty' do
    expect(ThinkingSphinx).to receive(:search).with('test')
    SearchService.call(query: 'test', resource: '')
  end

  SearchService::RESOURCES.each do |resource|
    it "calls #{resource}s search" do
      expect(resource.constantize).to receive(:search).with('test')
      SearchService.call(query: 'test', resource: resource)
    end
  end

  it 'search entire site when resource is not in list' do
    expect(ThinkingSphinx).to receive(:search).with('test')
    SearchService.call(query: 'test', resource: 'not_in_list')
  end
end
