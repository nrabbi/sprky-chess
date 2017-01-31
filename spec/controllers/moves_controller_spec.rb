require 'rails_helper'

RSpec.describe MovesController, type: :controller do
  describe "moves#index action" do
    it "should successfully show the page" do
      get :index, game_id: 2
      expect(response).to have_http_status(:success)
    end
  end

end
