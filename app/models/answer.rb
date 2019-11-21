class Answer < ApplicationRecord
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
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
    end
  end

end
