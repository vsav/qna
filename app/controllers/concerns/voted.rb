module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[like dislike unvote]
    before_action :check_author, only: %i[like dislike unvote]
  end

  def like
    @votable.like!(current_user)
    render_json
  end

  def dislike
    @votable.dislike!(current_user)
    render_json
  end

  def unvote
    @votable.votes.find_by(user_id: current_user)&.destroy
    render_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def check_author
    head 403 if current_user&.is_author?(@votable)
  end

  def render_json
    render json: { total_rating: @votable.total_rating, klass: @votable.class.to_s.downcase, votable_id: @votable.id }
  end
end
