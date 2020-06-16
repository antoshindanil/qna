# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :user_id
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  scope :best, -> { find_by(best: true) }

  def set_best
    transaction do
      question.answers.best&.update!(best: false)
      question.award&.update!(user_id: user_id)
      update!(best: true)
    end
  end
end
