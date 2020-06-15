# frozen_string_literal: true

require "rails_helper"

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let!(:user_awards) { create_list(:award, 3, user: user) }

  describe "GET #index" do
    before do
      login(user)
      get :index
    end

    it "populates an array of user rewards" do
      expect(assigns(:exposed_awards)).to eq(user_awards)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end
end
