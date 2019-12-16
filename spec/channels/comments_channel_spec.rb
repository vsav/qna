require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  let(:question) { create(:question) }

  it 'subscribes to CommentsChannel' do
    subscribe question_id: question.id
    perform :follow

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("questions/#{question.id}/comments")
  end
end
