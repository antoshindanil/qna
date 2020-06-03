# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  describe "POST #create" do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    before { login(user) }

    context "with valid attributes" do
      it "saves a new answer in the database" do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        }.to change(question.answers, :count).by(1)
      end

      it "redirects to question show view" do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        }.not_to change(question.answers, :count)
      end

      it "re-render show view" do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template "questions/show"
      end
    end
  end
end
