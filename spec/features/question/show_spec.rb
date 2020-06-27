require 'rails_helper'

feature 'User can view the question with answers', %q{
  In order to get answers to the question
  As an authenticated or UNauthenticated user
  I'd like to be able to view the question with answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Any user views the question with answers', js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  describe 'The best answer must be first', js: true do
    background do
      answers.last.set_best
      sign_in(user)
      visit question_path(question)
    end

    scenario 'when user sets the best answer' do
      within first(".answers") do
        expect(page).to have_content 'Best answer'
        expect(page).to have_content answers.last.body
      end
    end

    scenario 'when user changes the best answer', js: true do
      within find("#answer-#{answers.first.id}") do
        click_on 'Mark as the best answer'
      end

      within first(".answers") do
        expect(page).to have_content 'Best answer'
        expect(page).to have_content answers.first.body
      end
    end
  end
end
