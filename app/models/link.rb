# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: { public_suffix: true }

  def gist?
    url.match?(/gist.github.com/)
  end

  def gist_id
    url.split("/").last
  end
end
