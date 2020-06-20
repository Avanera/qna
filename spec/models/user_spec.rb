require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }

    it 'returns true if user is the author' do
      expect(author).to be_author_of(question)
    end

    it 'returns false if user is not the author' do
      expect(user).to_not be_author_of(question)
    end
  end
end
