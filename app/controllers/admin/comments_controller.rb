class Admin::CommentsController < ApplicationController
  
  def index
    @comments = Comment.all
    @users = User.all
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_path
  end
end
