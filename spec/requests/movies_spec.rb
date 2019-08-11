require "rails_helper"

describe "Movies requests", type: :request do
  let!(:movies) { create_list(:movie, 5, title: 'Godfather') }
  describe "movies list" do
    it "displays right title" do
      visit "/movies"
      expect(page).to have_selector("h1", text: "Movies")
    end
    it "displays movie details from the API on the index page" do
      visit "/movies"
      movie = Movie.find(1)
      response = JSON.parse HTTParty.get("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(movie.title)}").body
      @attributes = response["data"]["attributes"]
      @poster = "https://pairguru-api.herokuapp.com/#{@attributes["poster"]}"
      expect(page).to have_selector("img[src='#{@poster}']")
      expect(page).to have_content(@attributes["plot"])
      expect(page).to have_content(@attributes["rating"])
    end
    it "displays movie details from the API on show page" do
      visit "/movies/1"
      movie = Movie.find(1)
      response = JSON.parse HTTParty.get("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(movie.title)}").body
      @attributes = response["data"]["attributes"]
      @poster = "https://pairguru-api.herokuapp.com/#{@attributes["poster"]}"
      expect(page).to have_selector("img[src='#{@poster}']")
      expect(page).to have_content(@attributes["plot"])
      expect(page).to have_content(@attributes["rating"])
    end
  end
end
