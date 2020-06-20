class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[new create]
  expose :answer
  expose :answers, -> { question.answers }
  expose :question

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.user = current_user
    if answer.save
      redirect_to question, notice: 'Your answer successfully created'
    else
      flash.now[:alert] = "Your question was not saved"
      render 'questions/show'
    end
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
