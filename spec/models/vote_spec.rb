require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:vote) { create(:vote, user: user, votable: question) }

  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  it { should validate_presence_of :rating }
  it { should validate_uniqueness_of(:user).scoped_to([:votable_type, :votable_id]).with_message('you can like/dislike only once') }
  it { should validate_inclusion_of(:rating).in_range(-1..1) }
end
