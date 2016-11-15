class CommentsController < ApplicationController
  def index
    @product = Product.find(params[:product_id])
    @comments = @product.comments.order('comments.created_utc DESC')
  end
end
