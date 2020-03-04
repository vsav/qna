# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    user ? user_abilities : guest_abilities
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    guest_abilities

    can :read, Reward

    can :me, User

    can :read, User

    can :create, [Question, Answer, Comment, Subscription]

    can %i[update destroy], [Question, Answer], { user_id: user.id }

    can :destroy, Subscription, user_id: user.id

    can :destroy, Link do |link|
      user.is_author?(link.linkable)
    end

    can :manage, ActiveStorage::Attachment do |attachment|
      user.is_author?(attachment.record)
    end

    can :like, [Question, Answer] do |votable|
      !user.is_author?(votable) && !user.liked?(votable)
    end

    can :dislike, [Question, Answer] do |votable|
      !user.is_author?(votable) && !user.disliked?(votable)
    end

    can [:unvote], [Question, Answer] do |votable|
      user.voted?(votable)
    end

    can :set_best, Answer do |answer|
      user.is_author?(answer.question) && !user.is_author?(answer) && !answer.best?
    end
  end
end
