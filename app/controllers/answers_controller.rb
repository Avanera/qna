class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[new create]
  expose :answer
  expose :answers, -> { question.answers }
  expose :question

  def create
    @exposed_answer = question.answers.create(answer_params.merge({ user_id: current_user.id }))
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question, alert: 'Your answer successfully deleted'
    else
      redirect_to question, alert: "You can't delete the answer created by another person"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
