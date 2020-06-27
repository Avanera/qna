require 'rails_helper'

feature 'User can mark the best answer for his question', %q{
  In order to highlight the best answer for other users
  As an authenticated user
  I'd like to be able to mark the best answer for my question
} do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:user) { create(:user) }

  scenario 'The author sets the best answer for his question', js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      click_on 'Mark as the best answer'
    end

    expect(page).to have_content 'Best answer'
  end

  scenario "Authenticated user tries to set the best answer for another person's question", js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Mark as the best answer'
    end
  end

  scenario 'Unauthenticated user can not set the best answer', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Mark as the best answer'
    end
  end
end
