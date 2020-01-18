class Answer < ApplicationRecord

  include WithLinks
  include Votable
  include Commentable

  has_many_attached :files
  belongs_to :question, touch: true
  belongs_to :user
  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id, best: true }, if: :best?

  after_create :new_answer_notice

  default_scope -> { order('best DESC, created_at') }
  scope :best, -> { where(best: true) }

  def mark_best!
    transaction do
      question.answers.best.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end

  private

  def new_answer_notice
    NewAnswersJob.perform_later(self)
  end
end
