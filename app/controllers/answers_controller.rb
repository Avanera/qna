class AnswersController < ApplicationController
  before_action :question, only: %i[new create]
  expose :answers, -> { question.answers }
  expose :answer, -> { answers.new(answer_params) }

  def create
    if answer.save
      redirect_to answer.question
    else
      render :new
    end
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
