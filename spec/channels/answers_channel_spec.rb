# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let(:question) { create(:question) }

  it 'subscribes to AnswersChannel' do
    subscribe question_id: question.id
    perform :follow

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("questions/#{question.id}/answers")
  end
end
