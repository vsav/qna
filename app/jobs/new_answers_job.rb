class NewAnswersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerService.new.send_notice(answer) unless subscription.user.is_author?(answer)
    end
  end
end
