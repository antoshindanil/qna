# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, -> { order("best DESC, created_at") }, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: :user_id
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true
end
