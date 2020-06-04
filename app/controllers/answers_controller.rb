# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  expose :question, id: :question_id
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.author = current_user

    if answer.save
      redirect_to question, notice: "Your answer was successfully created."
    else
      render "questions/show"
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to answer.question, notice: "Answer was successfully deleted"
    else
      redirect_to answer.question, notice: "Can't delete the answer"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
