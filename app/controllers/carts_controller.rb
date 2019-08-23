class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
  end

  def show

  end

  def add_item
    item = Item.find(params[:item_id])
    item_id_str = item.id.to_s
    cart.add_item(item.id)
    session[:cart] = cart.contents

    quantity = session[:cart][item_id_str]
    flash[:notice] = "You now have #{pluralize(quantity, "#{item.name}")} in your cart."
    redirect_to "/items"
  end
end
