class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :oauth_providers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :email, email: true

  def is_author?(resource)
    resource.user_id == self.id
  end

  def liked?(resource)
    votes.exists?(votable: resource, rating: 1)
  end

  def disliked?(resource)
    votes.exists?(votable: resource, rating: -1)
  end

  def voted?(resource)
    votes.exists?(votable: resource)
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def subscribed?(question)
    subscriptions.find_by(question_id: question.id).present?
  end
end
