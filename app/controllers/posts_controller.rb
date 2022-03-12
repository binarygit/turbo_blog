class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(form_params)
    if @post.save
      respond_with_stream
    else
      render :new
    end
  end

  private

  def form_params 
    params.require(:post).permit(:title, :body)
  end

  def update_stream
    render turbo_stream: turbo_stream.update('all-posts', partial: 'post', 
                                             locals: {post: @post})
  end

  def prepend_stream
    render turbo_stream: turbo_stream.prepend('all-posts', partial: 'post', 
                                              locals: {post: @post})
  end

  def respond_with_stream
      respond_to do |format|

        format.turbo_stream do
          return update_stream if Post.count.eql?(1)
          prepend_stream
        end

      end
  end
end
