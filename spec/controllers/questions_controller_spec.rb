require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: {
          question: attributes_for(:question, :invalid)
        } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update'do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: {
          id: question, question: { title: 'new title', body: 'new body' }
        }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: {
          id: question, question: attributes_for(:question)
        }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:old_question) { question }

      before { patch :update, params: {
        id: question, question: attributes_for(:question, :invalid)
        }}

        it 'does not change question' do
          question.reload

          expect(question.title).to eq old_question.title
          expect(question.body).to eq old_question.body
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, user: author) }
    before { login(author) }

    context 'author' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }
        .to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'not-author' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }
          .to_not change(Question, :count)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to question
      end
    end
  end
end
