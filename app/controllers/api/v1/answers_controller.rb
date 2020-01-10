class Api::V1::AnswersController < Api::V1::BaseController

  authorize_resource

  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: [:show, :update, :destroy ]

  def index
    render json: @question.answers
  end

  def show
    render json: @answer
  end

  def create
    answer = @question.answers.new(answer_params)
    answer.user = current_resource_owner

    if answer.save
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @answer.destroy!
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question ||= Question.find(params[:question_id])
  end

  def find_answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
