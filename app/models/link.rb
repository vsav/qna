class Link < ApplicationRecord
  URL_FORMAT = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
  GIST_URL = /https:\/\/gist.github.com\/\w+\/(\w+)/

  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true
  validates :url, format: { with: URL_FORMAT, message: 'must be a valid URL format' }

  def gist?
    url.match(GIST_URL)
  end

  def gist_content
    begin
      client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
      gist = client.gist(url.split("/").last)
      file = {}
      gist.files.each { |_, v| file = v }
      file.content
    rescue Octokit::NotFound
      'URL not found'
    end
  end
end
