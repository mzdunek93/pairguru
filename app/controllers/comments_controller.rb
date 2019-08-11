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
end
