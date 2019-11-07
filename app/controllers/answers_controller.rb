class AnswersController < ApplicationController

  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :set_best]
  before_action :authenticate_user!, except: [:index, :show]

  def create
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user
    @answer.save
  end

  def show; end

  def edit; end

  def update
    @question = @answer.question
    if current_user.is_author?(@answer)
      @answer.update(answer_params)
    else
      redirect_to root_path
    end
  end

  def destroy
    if current_user.is_author?(@answer)
      @answer.destroy
    else
      redirect_to root_path
    end
  end

  def set_best
    @question = @answer.question
    if current_user.is_author?(@answer)
      @answer.mark_best
    else
      redirect_to root_path
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
