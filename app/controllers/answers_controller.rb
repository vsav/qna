class AnswersController < ApplicationController

  include Voted

  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :set_best]
  before_action :authenticate_user!, except: [:index, :show]
  after_action :publish_answer, only: :create

  def create
    @answer = Answer.create(answer_params.merge(question: @question,
                                                user: current_user))
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
    if current_user.is_author?(@question)
      @answer.mark_best!
    else
      redirect_to root_path
    end
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}/answers",
      html: html(@answer),
      answer: @answer,
      question: @answer.question
    )
  end

  def html(answer)
    wardenize
    @job_renderer.render(
      partial: 'answers/answer',
      locals: { answer: answer }
    )
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def wardenize
    @job_renderer = ::AnswersController.renderer.new
    renderer_env = @job_renderer.instance_eval { @env }
    warden = ::Warden::Proxy.new(renderer_env, ::Warden::Manager.new(Rails.application))
    renderer_env['warden'] = warden
  end

end
