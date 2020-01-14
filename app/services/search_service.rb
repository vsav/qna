class SearchService

  RESOURCES = %w[Question Answer Comment User]

  def self.call(params)
    @input = params[:input]
    @resource = params[:resource]
    RESOURCES.include?(@resource) ? @resource.constantize.search(@input) : ThinkingSphinx.search(@input)
  end
end
