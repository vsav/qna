class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
  validate :best_uniqueness, on: :best

  default_scope -> { order('best DESC, created_at') }
  scope :best, -> { where(best: true) }

  def mark_best
    previous_best = question.answers.find_by(best: true)
    previous_best&.update!(best: false)
    self.update!(best: true)
  end

  private

  def best_uniqueness
    errors.add(:answer, 'Only one answer can be marked as best') if question.answers.best.count > 1
  end

end
