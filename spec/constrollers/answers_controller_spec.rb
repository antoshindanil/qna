# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question }

  describe "POST #create" do
    before { login(user) }

    context "with valid answer" do
      it "saves a new answer in the database" do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }
          .to change(question.answers, :count).by(1)
      end

      it "answer belongs to the author" do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }

        expect(user).to be_author_of(assigns(:exposed_answer))
      end

      it "redirects to question show view" do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end

    context "with invalid answer" do
      it "does not save the answer" do
        expect {
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        }.not_to change(Answer, :count)
      end

      it "re-renders questions create view" do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:answer) { create(:answer, question: question) }

    context "when authenticated user is answer's author" do
      before { login(answer.author) }

      it "deletes the question" do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it "render destroy view" do
        delete :destroy, params: { id: answer, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context "when authenticated user is not answer's author" do
      let(:user1) { create(:user) }

      before { login(user1) }

      it "cannot delete the question" do
        expect { delete :destroy, params: { id: answer, format: :js } }.not_to change(Answer, :count)
      end

      it "render destroy view" do
        delete :destroy, params: { id: answer, format: :js }

        expect(response).to render_template :destroy
      end
    end
  end

  describe "PATCH #update" do
    let!(:answer) { create(:answer, question: question) }

    before { login(answer.author) }

    context "with valid attributes" do
      it "changes answer attributes" do
        patch :update, params: { id: answer, answer: { body: "new body" } }, format: :js
        answer.reload
        expect(answer.body).to eq "new body"
      end

      it "renders update view" do
        patch :update, params: { id: answer, answer: { body: "new body" } }, format: :js
        expect(response).to render_template :update
      end
    end

    context "with invalid attributes" do
      it "does not change answer attributes" do
        expect {
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        }.not_to change(answer, :body)
      end

      it "renders update view" do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe "PATCH #best" do
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question) }

    context "when the author of the question set best the answer" do
      before { login(question.author) }

      it "set answer as the best" do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it "renders best view" do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context "when a non-author of the question" do
      let(:user1) { create(:user) }

      before { login(user1) }

      it "cannot set the answer as the best" do
        patch :best, params: { id: answer }, format: :js
        expect(answer).not_to be_best
      end

      it "renders best view" do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end
  end
end
