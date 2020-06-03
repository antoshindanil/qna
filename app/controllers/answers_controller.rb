# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question, id: :question_id
  expose :answer
  before_action :authenticate_user!

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.author = current_user

    if answer.save
      redirect_to question, notice: "Your answer was successfully created."
    else
      redirect_to question, notice: "Body can't be blank"
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question_path(answer.question), notice: "Answer was successfully deleted"
    else
      redirect_to question_path(answer.question), notice: "Can't delete the answer"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
