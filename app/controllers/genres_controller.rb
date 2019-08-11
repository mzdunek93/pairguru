class GenresController < ApplicationController
  def index
    @genres = Genre.all.decorate
  end

  def movies
    @genre = Genre.find(params[:id]).decorate
    titles = @genre.movies.map(&:title).uniq
    @details = Hash.new
    threads = []
    titles.each do |title|
      threads << Thread.new do
        response = JSON.parse HTTParty.get("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(title)}").body
        @details[title] = response["data"]["attributes"]
        @details[title]["poster"] = "https://pairguru-api.herokuapp.com/#{@details[title]["poster"]}"
      end
    end
    threads.each(&:join)
  end
end
