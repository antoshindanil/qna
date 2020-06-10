# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :user_id

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  scope :best, -> { find_by(best: true) }

  def set_best
    transaction do
      question.answers.best&.update(best: false)
      update!(best: true)
    end
  end
end
