# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :rating, presence: true
  validates :user, uniqueness: { scope: %i[votable_type votable_id],
                                 message: 'you can like/dislike only once' }
  validates_inclusion_of :rating, in: [-1, 1]
end
