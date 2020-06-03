# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question, id: :question_id
  expose :answer, parent: :question
  before_action :authenticate_user!

  def create
    if answer.save
      redirect_to question, notice: "Your answer was successfully created."
    else
      render "questions/show"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
