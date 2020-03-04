# frozen_string_literal: true

class SearchController < ApplicationController
  skip_authorization_check only: :results

  def results
    @result = SearchService.call(query: params[:query], resource: params[:resource])
  end
end
