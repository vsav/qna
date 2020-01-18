class Link < ApplicationRecord

  include ActiveModel::Validations

  GIST_URL = /https:\/\/gist.github.com\/\w+\/(\w+)/

  belongs_to :linkable, polymorphic: true, touch: true
  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    url.match(GIST_URL)
  end

end
