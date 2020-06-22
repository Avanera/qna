require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer for the given question in the database' do
        expect { post :create, params: {
          answer: attributes_for(:answer), question_id: question
        }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'belongs to the user' do
        post :create, params: {
          answer: attributes_for(:answer), question_id: question }, format: :js

        expect(assigns(:exposed_answer).user_id).to eq(user.id)
      end

      it 'renders create template' do
        post :create, params: {
          answer: attributes_for(:answer), question_id: question
        }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: {
          answer: attributes_for(:answer, :invalid), question_id: question
        }, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders create template' do
        post :create, params: {
          answer: attributes_for(:answer, :invalid), question_id: question
        }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect { patch :update, params: {
          id: answer, answer: { body: 'new body' }
        }, format: :js }.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'not-author' do
      let!(:another_user) { create(:user) }
      before { login(another_user) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
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
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }
        .to change(Answer, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'not-author' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }
          .to_not change(Answer, :count)
        end

        it 'renders destroy' do
          delete :destroy, params: { question_id: question, id: answer }, format: :js

          expect(response).to render_template :destroy
      end
    end
  end
end
