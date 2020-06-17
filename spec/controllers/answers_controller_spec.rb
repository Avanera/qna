require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer for the given question in the database' do
        expect { post :create, params: {
          answer: attributes_for(:answer), question_id: question
        }}.to change(question.answers, :count).by(1)
        expect(answer.user_id).to eq(user.id)
      end

      it 'redirects to question show view' do
        post :create, params: {
          answer: attributes_for(:answer), question_id: question
        }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: {
          answer: attributes_for(:answer, :invalid), question_id: question
        }}.to_not change(question.answers, :count)
      end

      it 're-renders question' do
        post :create, params: {
          answer: attributes_for(:answer, :invalid), question_id: question
        }

        expect(response).to redirect_to question
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, user: author) }
    let!(:answer) { create(:answer, question: question, user: author) }
    before { login(author) }

    context 'author' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }
        .to change(author.answers, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer }

        expect(response).to redirect_to question
      end
    end

    context 'not-author' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { question_id: question, id: answer } }
          .to_not change(Answer, :count)
        expect(response).to redirect_to question
      end
    end
  end
end
