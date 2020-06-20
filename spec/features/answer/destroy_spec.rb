require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to remove the answer
  As an authenticated user
  I'd like to be able to delete my answer
} do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author)}
  given!(:answer) { create(:answer, question: question, user: author)}
  given(:user) { create(:user) }

  describe 'Authenticated user' do

    scenario 'deletes his own answer' do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete the answer'

      expect(page).to have_content 'Your answer successfully deleted'
      expect(page).to_not have_content answer.body
    end

    scenario 'tries to delete not his own answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete the answer'
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete the answer'
  end
end
