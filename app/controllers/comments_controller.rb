class CommentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    comment = Comment.find(params[:id])
    if current_user != comment.user
      redirect_back(fallback_location: root_path, alert: "Permission error")
    elsif comment.destroy
      redirect_back(fallback_location: root_path, notice: "Comment deleted")
    else
      redirect_back(fallback_location: root_path, alert: "Error when deleting comment")
    end
  end

  def top_commenters
    @commenters = Comment
      .select("COUNT(comments.user_id) as comments_count, users.*")
      .joins(:user)
      .where("comments.created_at >= :date", date: 7.days.ago)
      .group(:user_id)
      .order("comments_count DESC")
      .limit(10)
    puts @commenters.to_json
  end
end
