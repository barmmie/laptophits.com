class CommentsController < ApplicationController
  def index
    @product = Product.find(params[:product_id])
    @comments = @product.comments.order('comments.created_utc DESC')
    @comments = @comments.where('comments.created_utc > ?', Time.now - ::TimeAbbr.to_time(params[:after])) if params[:after]
  end
end
