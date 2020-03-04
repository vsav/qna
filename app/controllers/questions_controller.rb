# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]
  before_action :find_subscription, only: %i[show edit update]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      gon.question_id = @question.id
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted.'
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      html: html(@question),
      question: @question
    )
  end

  def html(question)
    ApplicationController.render(
      partial: 'questions/question_header',
      locals: { question: question }
    )
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[title image])
  end

  def find_subscription
    @subscription = @question.subscriptions.find_by(user_id: current_user&.id)
  end
end
