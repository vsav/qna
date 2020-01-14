class SearchController < ApplicationController

  skip_authorization_check only: :results

  def results
    @result = SearchService.call(search_params)
  end

  private

  def search_params
    params.permit(:input, :resource)
  end
end
