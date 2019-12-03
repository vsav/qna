class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :rating, presence: true
  validates :user, uniqueness: { scope: [:votable_type, :votable_id], message: 'you can like/dislike only once' }
  validates_inclusion_of :rating, in: -1..1
end
