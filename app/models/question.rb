class Question < ApplicationRecord

  include WithLinks
  include Votable

  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many_attached :files
  accepts_nested_attributes_for :reward, reject_if: :all_blank
  belongs_to :user
  validates :title, :body, presence: true
end
