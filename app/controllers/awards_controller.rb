# frozen_string_literal: true

class AwardsController < ApplicationController
  before_action :authenticate_user!
  expose :awards, from: :current_user

  def index
    awards
  end
end
