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

    scenario 'answers the question' do
      fill_in 'Your answer', with: 'answer answer answer'
      click_on 'Answer the question'

      expect(page).to have_content 'Your answer successfully created'
      expect(page).to have_content 'answer answer answer'
    end

    scenario 'answers the question with errors' do
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
