class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if current_user.is_author?(@question) && @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      flash[:alert] = 'Question was not updated.'
      render :edit
    end
  end

  def destroy
    if current_user.is_author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question was successfully deleted.'
    else
      flash[:alert] = 'You do not have permission to do that'
      render :show
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
