require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unregistered user
  I'd like to be able to sign up
} do

  given(:user) {create(:user)}
  background { visit new_user_registration_path }
  describe 'Unregistered user' do

    scenario 'signs up' do
      fill_in 'Email', with: 'email@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'tries to sign up with invalid data' do
      fill_in 'Password', with: '1'
      click_on 'Sign up'

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password is too short (minimum is 6 characters)"
      expect(page).to have_content "Password confirmation doesn't match"
    end
  end

  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
