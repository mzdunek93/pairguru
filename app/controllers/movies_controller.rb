class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.includes(:genre).decorate
    titles = @movies.map(&:title).uniq
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

  def show
    @movie = Movie.find(params[:id])
    response = JSON.parse HTTParty.get("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(@movie.title)}").body
    @attributes = response["data"]["attributes"]
    @poster = "https://pairguru-api.herokuapp.com/#{@attributes["poster"]}"
  end

  def send_info
    movie = Movie.find(params[:id])
    SendMovieInfoJob.perform_later(current_user, movie)
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    ExportMoviesJob.perform_later(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end
end
