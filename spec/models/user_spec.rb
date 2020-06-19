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
    let(:answer) { create(:answer, question: question, user: author) }

    it 'returns true if user is the author' do
      quiry1 = author.author_of?(answer)
      quiry2 = author.author_of?(question)

      expect(quiry1).to be true
      expect(quiry2).to be true
    end

    it 'returns false if user is not the author' do
      quiry1 = user.author_of?(answer)
      quiry2 = user.author_of?(question)

      expect(quiry1).to be false
      expect(quiry2).to be false
    end
  end

end
