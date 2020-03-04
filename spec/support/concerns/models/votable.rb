# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for Votable do
  it { should have_many(:votes).dependent(:destroy) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:user4) { create(:user) }
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
      it 'changes votable total rating by 1' do
        expect(votable.total_rating).to eq 0
        votable.like!(user4)
        expect(votable.total_rating).to eq 1
      end

      it 'changes votable rating only once per user like' do
        expect(votable.total_rating).to eq 0
        votable.like!(user4)
        expect(votable.total_rating).to eq 1
        votable.like!(user4)
        expect(votable.total_rating).to eq 1
      end
    end

    describe '#dislike?' do
      it 'changes votable rating by -1' do
        expect(votable.total_rating).to eq 0
        votable.dislike!(user4)
        expect(votable.total_rating).to eq(-1)
      end
    end
  end
end
