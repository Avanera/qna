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
        }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: {
          id: question, question: attributes_for(:question)
        }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
        it 'does not change question' do
          expect do
            patch :update, params: {
              id: question, question: attributes_for(:question, :invalid)
              }, format: :js
          end.to_not change(question, :body)
        end

        it 'renders update view' do
          patch :update, params: {
            id: question, question: attributes_for(:question, :invalid)
            }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'not-author' do
        let!(:another_user) { create(:user) }
        before { login(another_user) }

        it 'does not change question attributes' do
          expect do
            patch :update, params: {
              id: question, question: attributes_for(:question)
              }, format: :js
          end.to_not change(question, :body)
        end

        it 'renders update view' do
          patch :update, params: {
            id: question, question: attributes_for(:question)
            }, format: :js

          expect(response).to render_template :update
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

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new answer for the question' do
      expect(assigns(:exposed_answer)).to be_a_new(Answer)
    end
  end
end
