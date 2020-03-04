# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  URL_FORMAT = %r{(^$)|(^(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?/.*)?$)}ix.freeze

  def validate_each(record, attribute, value)
    return true if value =~ URL_FORMAT

    record.errors[attribute] << url_error_message
  end

  private

  def url_error_message
    options[:message] || 'must be a valid URL format'
  end
end
