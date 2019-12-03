class Answer < ApplicationRecord

  include WithLinks
  include Votable

  has_many_attached :files
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id, best: true }, if: :best?

  default_scope -> { order('best DESC, created_at') }
  scope :best, -> { where(best: true) }

  def mark_best!
    transaction do
      question.answers.best.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
