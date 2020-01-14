require 'rails_helper'

RSpec.describe SearchService do
  it 'calls entire site search' do
    expect(ThinkingSphinx).to receive(:search).with('test')
    SearchService.call(input: 'test', resource: '')
  end

  SearchService::RESOURCES.each do |resource|
    it "calls #{resource}s search" do
      expect(resource.constantize).to receive(:search).with('test')
      SearchService.call(input: 'test', resource: resource)
    end
  end
end
