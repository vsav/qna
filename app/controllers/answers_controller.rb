class AnswersController < ApplicationController

  before_action :find_question, only: [:create, :edit, :update, :destroy]
  before_action :find_answer, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created.'
    else
      render 'questions/show'
    end
  end

  def show; end

  def edit; end

  def update
    if current_user.is_author?(@answer) && @answer.update(answer_params)
      redirect_to question_answer_path(@answer), notice: 'Answer was successfully updated.'
    else
      flash[:alert] = 'Answer was not updated'
      render :edit
    end
  end

  def destroy
    if current_user.is_author?(@answer)
      @answer.destroy
      redirect_to question_answers_path(@question), notice: 'Answer was successfully deleted.'
    else
      flash[:alert] = 'You do not have permission to do that'
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
