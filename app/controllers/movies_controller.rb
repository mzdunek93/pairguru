class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.includes(:genre).decorate
    titles = @movies.map(&:title).uniq
    @details = Hash.new
    titles.each do |title|
      response = JSON.parse HTTParty.get("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(title)}").body
      @details[title] = response["data"]["attributes"]
      @details[title]["poster"] = "https://pairguru-api.herokuapp.com/#{@details[title]["poster"]}"
    end
  end

  def show
    @movie = Movie.find(params[:id])
    response = JSON.parse HTTParty.get("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(@movie.title)}").body
    @attributes = response["data"]["attributes"]
    @poster = "https://pairguru-api.herokuapp.com/#{@attributes["poster"]}"
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, movie).deliver_now
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end
end
