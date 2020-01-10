class Api::V1::QuestionsController < Api::V1::BaseController

  authorize_resource

  before_action :find_question, only: [:show, :update, :destroy]

  def index
    questions = Question.all
    render json: questions
  end

  def show
    render json: @question
  end

  def create
    question = Question.create(question_params)
    question.user = current_resource_owner

    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy!
      head :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
