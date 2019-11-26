class Link < ApplicationRecord
  URL_FORMAT = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
  GIST_URL = /https:\/\/gist.github.com\/\w+\/(\w+)/

  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true
  validate :validate_url_format, on: :create

  def gist?
    url.match(GIST_URL)
  end

  private

  def validate_url_format
    unless url =~ URL_FORMAT
      errors.add(:url, 'must be a valid URL format')
    end
  end
end
