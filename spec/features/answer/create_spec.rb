require 'rails_helper'

feature 'User can create an answer', %q{
  In order to answer the question
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'Your answer', with: 'answer answer answer'
      click_on 'Answer the question'

      expect(current_path).to eq question_path(question)
      within '.answers' do # to make sure that the answer is in the list, not in the form
        expect(page).to have_content 'answer answer answer'
      end
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Answer the question'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Answer the question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
