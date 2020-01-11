class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: Date.yesterday)

    mail to: user.email,
         subject: 'Yesterday questions from QnA'
  end
end
