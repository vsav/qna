class AnswersController < ApplicationController

  before_action :find_question, only: [:index, :new]

  def index
    @answers = @question.answers.all
    #@answers = Answer.all
  end

  def new
    @answer = @question.answers.new
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
