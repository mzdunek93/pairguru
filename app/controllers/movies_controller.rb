class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info, :add_comment]

  def index
    @movies = Movie.all.decorate
  end

  def show
    @comment = Comment.new
    @movie = Movie.find(params[:id])
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, @movie).deliver_now
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end

  def add_comment
    movie = Movie.find(params[:id])
    if movie.comments.any? { |comment| comment.user_id == current_user.id }
      redirect_back(fallback_location: root_path, alert: "You already posted a comment")
    else
      comment = Comment.new(comment_params)
      comment.movie = movie
      comment.user = current_user
      if comment.save
        redirect_back(fallback_location: root_path, notice: "Comment added")
      else
        redirect_back(fallback_location: root_path, alert: "Error when adding comment")
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
