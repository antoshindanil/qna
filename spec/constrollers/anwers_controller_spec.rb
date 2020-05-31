# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let!(:answer) { create(:answer) }
  let(:question) { answer.question }

  describe "POST #create" do
    context "with valid attributes" do
      it "saves a new answer in the database" do
        expect {
          post :create, params: {question_id: question, answer: attributes_for(:answer)}
        }.to change(Answer, :count).by(1)
      end

      it "redirects to question show view" do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to question_path(:question)
      end
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect {
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}
        }.not_to change(Answer, :count)
      end

      it "re-render new view" do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}
        expect(response).to render_template :new
      end
    end
  end
end
