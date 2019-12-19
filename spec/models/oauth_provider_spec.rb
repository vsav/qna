require 'rails_helper'

RSpec.describe OauthProvider, type: :model do
  let(:user) { create(:user) }
  let!(:provider) { create(:oauth_provider, uid: 'aaa', user: user) }

  it { should belong_to :user }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:uid).scoped_to(:provider).with_message("You're  already have linked #{@provider} account") }
end
