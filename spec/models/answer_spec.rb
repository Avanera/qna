require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#set_best' do
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let!(:answer1) { create(:answer, question: question, user: author) }
    let!(:answer2) { create(:answer, best: true, question: question, user: author) }

    before { answer1.set_best }

    it 'sets new answer best attribute to true' do
      expect(answer1.best).to be true
    end

    it 'sets old answer best attribute to false' do
      answer2.reload
      expect(answer2.best).to be false
    end
  end
end
