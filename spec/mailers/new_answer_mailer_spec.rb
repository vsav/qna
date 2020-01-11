require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe 'New answer notice' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question, user: user }
    let(:mail) { NewAnswerMailer.notice(user, answer) }

    it 'prepares emails' do
      expect(mail.subject).to eq("User #{ answer.user.email } just answered your question: #{question.title}")
      expect(mail.to).to eq([user.email])
    end

    it 'prepares correct email body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end

end
