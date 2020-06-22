class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[new create]
  expose :answer
  expose :answers, -> { question.answers }
  expose :question

  def create
    @exposed_answer = question.answers.create(answer_params.merge({ user_id: current_user.id }))
  end

  def update
    @exposed_answer = Answer.find(params[:id])
    if current_user.author_of?(answer)
      answer.update(answer_params)
      @exposed_question = answer.question
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
