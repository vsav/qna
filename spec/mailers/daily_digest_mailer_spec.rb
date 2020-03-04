# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create :user }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:yesterday_questions) { create_list :question, 2, title: 'Yesterday question', created_at: Date.yesterday }
    let!(:today_questions) { create_list :question, 2, title: 'Today question', created_at: Date.today }

    it 'prepares emails' do
      expect(mail.subject).to eq 'Yesterday questions from QnA'
      expect(mail.to).to eq [user.email]
    end

    it 'prepares only yesterday questions' do
      expect(mail.body.encoded).to match(yesterday_questions.last.title)
      expect(mail.body.encoded).to_not match(today_questions.last.title)
    end
  end
end
