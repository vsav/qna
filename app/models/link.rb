class Link < ApplicationRecord
  URL_FORMAT = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
  GIST_URL = /https:\/\/gist.github.com\/\w+\/(\w+)/

  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true
  validates :url, format: { with: URL_FORMAT, message: 'must be a valid URL format' }

  def gist?
    url.match(GIST_URL)
  end
end
