require "rails_helper"

describe "API requests", type: :request do
  include Rack::Test::Methods
  let!(:genres) { create_list(:genre, 5, :with_movies) }
  describe "movies list" do
    it "returns movie ids and titles" do
      get "/api/movies"

      assert last_response.ok?
      response = JSON.parse(last_response.body)
      expect(response.size).to eq(Movie.count)
      first = response.first
      movie = Movie.first
      expect(first["id"]).to eq(movie.id)
      expect(first["title"]).to eq(movie.title)
      expect(first["genre_id"]).to be_nil
      expect(first["genre_name"]).to be_nil
      expect(first["genre_movies_count"]).to be_nil
    end
    it "returns genre details if asked" do
      get "/api/movies?include_genre=1"

      assert last_response.ok?
      response = JSON.parse(last_response.body)
      expect(response.size).to eq(Movie.count)
      first = response.first
      movie = Movie.first
      expect(first["id"]).to eq(movie.id)
      expect(first["title"]).to eq(movie.title)
      expect(first["genre_id"]).to eq(movie.genre_id)
      expect(first["genre_name"]).to eq(movie.genre.name)
      expect(first["genre_movies_count"]).to eq(movie.genre.movies.count)
    end
  end
  describe "movie endpoint" do
    it "returns movie id and title" do
      get "/api/movies/1"

      movie = Movie.find(1)
      assert last_response.ok?
      response = JSON.parse(last_response.body)
      expect(response["id"]).to eq(movie.id)
      expect(response["title"]).to eq(movie.title)
      expect(response["genre_id"]).to be_nil
      expect(response["genre_name"]).to be_nil
      expect(response["genre_movies_count"]).to be_nil
    end
    it "returns genre details if asked" do
      get "/api/movies/1?include_genre=1"

      movie = Movie.find(1)
      assert last_response.ok?
      response = JSON.parse(last_response.body)
      expect(response["id"]).to eq(movie.id)
      expect(response["title"]).to eq(movie.title)
      expect(response["genre_id"]).to eq(movie.genre_id)
      expect(response["genre_name"]).to eq(movie.genre.name)
      expect(response["genre_movies_count"]).to eq(movie.genre.movies.count)
    end
  end
end
