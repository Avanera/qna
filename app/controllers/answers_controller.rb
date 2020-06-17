class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[new create]
  expose :answer
  expose :answers, -> { question.answers }

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.user_id = current_user.id
    if answer.save
      redirect_to question_path(question), notice: 'Your answer successfully created'
    else
      redirect_to question_path(question), alert: "Your answer can't be blank"
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

  def question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
