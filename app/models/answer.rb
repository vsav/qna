class Answer < ApplicationRecord
  belongs_to :question, dependent: :destroy
  validates :body, presence: true
end
