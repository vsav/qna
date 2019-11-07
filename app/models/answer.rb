class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
  validates_uniqueness_of :best, if: :best , on: :create

  default_scope -> { order('best DESC, created_at') }
  scope :best, -> { where(best: true) }

  def mark_best!
    transaction do
      question.answers.best.update_all(best: false)
      update!(best: true)
    end
  end

end
