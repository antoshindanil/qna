# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  expose :questions, -> { Question.all }
  expose :question
  expose :answer, -> { question.answers.new }

  def create
    @exposed_question = current_user.questions.new(question_params)

    if question.save
      redirect_to question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to question, notice: "Question was successfully deleted"
    else
      redirect_to question, notice: "Can't delete the question"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
