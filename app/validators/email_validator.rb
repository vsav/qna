class EmailValidator < ActiveModel::EachValidator

  EMAIL_FORMAT = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i

  def validate_each(record, attribute, value)
    return true if value =~ EMAIL_FORMAT
    record.errors[attribute] << email_error_message
  end

  private

  def email_error_message
    options[:message] || 'must be a valid email format'
  end
end
