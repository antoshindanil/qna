# frozen_string_literal: true

require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "POST #create" do
    before { login(user) }

    context "with valid attributes" do
      it "saves a new question in the database" do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
      end

      it "question belongs to the user who is created it" do
        post :create, params: { question: attributes_for(:question) }

        expect(user).to be_author_of(assigns(:exposed_question))
      end

      it "redirects to show view" do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context "with invalid attributes" do
      it "does not save the question" do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.not_to change(Question, :count)
      end

      it "re-renders new view" do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    let(:question) { create(:question) }

    before { login(question.author) }

    context "with valid attributes" do
      it "assigns requested question to @question" do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq assigns(:question)
      end

      it "changes question attributes" do
        patch :update, params: { id: question, question: { title: "new title", body: "new body" }, format: :js }
        question.reload

        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end

      it "redirects to updated question" do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context "with invalid attributes" do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

      it "does not change question" do
        question.reload

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it "renders update view" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:question) { create(:question) }

    context "when authenticated user is author" do
      before { login(question.author) }

      it "deletes the question" do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context "when authenticated user is't author" do
      let(:user1) { create(:user) }

      before { login(user1) }

      it "cannot delete the question" do
        expect {
          delete :destroy, params: { id: question }
        }.not_to change(Question, :count)
      end

      it "redirects to question" do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to assigns(:exposed_question)
      end
    end
  end
end
