class GenresController < ApplicationController
  def index
    @genres = Genre.all.decorate
  end

  def movies
    @genre = Genre.find(params[:id]).decorate
    titles = @genre.movies.map(&:title).uniq
    @details = Hash.new
    titles.each do |title|
      response = JSON.parse HTTParty.get("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(title)}").body
      if response["data"]
        @details[title] = response["data"]["attributes"]
        @details[title]["poster"] = "https://pairguru-api.herokuapp.com/#{@details[title]["poster"]}"
      end
    end
  end
end
