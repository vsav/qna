require 'rails_helper'

RSpec.describe User, type: :model do
  # модель тестировать не обязательно, т.к. это делает devise
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
