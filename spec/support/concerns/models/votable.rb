require 'rails_helper'

RSpec.shared_examples_for Votable do
  it { should have_many(:votes).dependent(:destroy) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:votable) { create(:question, user: user1) }
  let!(:vote1) { create(:vote, :like, user: user2, votable: votable) }
  let!(:vote2) { create(:vote, :dislike, user: user3, votable: votable) }

  describe 'users can vote' do

    describe '#total_votes' do
      it 'calculate votable total rating' do
        expect(votable.total_rating).to eq 0
      end
    end

    describe '#like' do
      before do
        votable.like!(user3)
      end

      it 'changes votable rating by 2' do
        expect(votable.total_rating).to eq 2
      end

      it 'changes votable rating only once per user like' do
        expect(votable.total_rating).to eq 2
        votable.like!(user3)
        expect(votable.total_rating).to eq 2
      end
    end

    describe '#dislike?' do
      before do
        votable.like!(user3)
      end
      it 'changes votable rating by -2' do
        expect(votable.total_rating).to eq 2
        votable.dislike!(user3)
        expect(votable.total_rating).to eq 0
      end
    end

  end
end
