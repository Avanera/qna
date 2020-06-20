require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to choose a question
  As an authenticated or UNauthenticated user
  I'd like to be able to view the list of questions
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'Any user views the list of questions' do
    visit questions_url
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
