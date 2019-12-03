module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def like!(user)
    vote(user, 1)
  end

  def dislike!(user)
    vote(user, -1)
  end

  def total_rating
    votes.sum(:rating)
  end

  private

  def vote(user, value)
    transaction do
      votes.where(user_id: user.id).delete_all
      votes.create!(user: user, rating: value)
    end
  end
end
