class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(form_params)
    if @post.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :new
    end
  end

  private

  def form_params 
    params.require(:post).permit(:title, :body)
  end
end
