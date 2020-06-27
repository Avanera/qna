class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_best
    previous_best_answer = question.answers.find_by(best: true)
    previous_best_answer&.update(best: false)
    self.update(best: true)
  end
end
