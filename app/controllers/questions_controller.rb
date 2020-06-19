class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  expose :questions, ->{ Question.all }
  expose :question

  def show
    @exposed_answer = Answer.new
  end

  def create
    @exposed_question = current_user.questions.new(question_params)
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      # flash.now[:notice] = ''
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, alert: 'Your question successfully deleted'
    else
      redirect_to question, alert: "You can't delete the question created by another person"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
