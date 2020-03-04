# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswersJob, type: :job do
  let(:service) { double('NewAnswersService') }
  let(:answer) { create :answer }

  before do
    allow(NewAnswerService).to receive(:new).and_return(service)
  end

  it 'calls NewAnswersService#send_notice' do
    expect(service).to receive(:send_notice)
    NewAnswersJob.perform_now(answer)
  end
end
