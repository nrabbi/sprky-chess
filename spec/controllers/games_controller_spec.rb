require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#show action" do
    it "should successfully show the page" do
      # TODO: need to complete this test
      # TODO: use factory girl to create players and game
      # get :show, id: game.id
      # expect(response).to have_http_status(:success)
    end
  end
  
  describe "games#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "games#create action" do
    it "should successfully create a new game in the database" do
      # TODO: need to complete this test.
    end
  end
  
end
