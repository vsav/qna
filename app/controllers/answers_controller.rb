class AnswersController < ApplicationController

  before_action :find_question, only: [:create, :edit, :update, :destroy]
  before_action :find_answer, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    #@answers = @question.answers.all
  end

  def new
    # @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to question_path(@question), notice: 'Answer was successfully created.'
    else
      render 'questions/show'
    end
  end

  def show; end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to question_answer_path(@answer)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_answers_path(@question), notice: 'Answer was successfully deleted.'
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
