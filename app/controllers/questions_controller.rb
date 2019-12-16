class QuestionsController < ApplicationController

  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: :create

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
    if current_user.is_author?(@question)
      @question.update(question_params)
    else
      redirect_to root_path
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
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:title, :image])
  end
end
