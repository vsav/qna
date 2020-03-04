# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "questions/#{question_id}/comments",
      html: html(@comment),
      comment: @comment
    )
  end

  def html(comment)
    ApplicationController.render(
      partial: 'comments/comment',
      locals: { comment: comment }
    )
  end

  private

  def find_commentable
    klass = [Answer, Question].find { |k| params["#{k.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def question_id
    if @commentable.is_a? Answer
      @commentable.question.id
    else
      @commentable.id
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
