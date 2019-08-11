class Api::MoviesController < ApplicationController
  def index
    if params[:include_genre]
      @movies = Movie
        .select("movies.*, genres.name as genre_name, COUNT(M.id) as genre_movies_count")
        .joins(:genre)
        .joins("LEFT OUTER JOIN movies M ON (movies.genre_id = M.genre_id)")
        .group(:id)
      render json: @movies.to_json(only: [:id, :title, :genre_id, :genre_name, :genre_movies_count])
    else
      @movies = Movie.all
      render json: @movies
    end
  end

  def show
    if params[:include_genre]
      @movies = Movie
        .select("movies.*, genres.name as genre_name, COUNT(M.id) as genre_movies_count")
        .joins(:genre)
        .joins("LEFT OUTER JOIN movies M ON (movies.genre_id = M.genre_id)")
        .where(id: params[:id])
        .group(:id)
        .first
      render json: @movies.to_json(only: [:id, :title, :genre_id, :genre_name, :genre_movies_count])
    else
      @movie = Movie.find(params[:id])
      render json: @movie
    end
  end
end
