module ProductsHelper
  def product_row product
    product_price = "$#{product.price_in_cents/100.to_f}" if product.price_in_cents
    [link_to(product.title, product.offer_url),
     product_price,
     link_to("#{product.product_count} mentions", product_comments_path(product, after: params[:after]))].reject(&:nil?).join(' - ').html_safe
  end
end
