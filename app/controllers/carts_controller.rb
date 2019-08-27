class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    cart = Cart.new(session[:cart])
    item = Item.find(params[:item_id])
    # item_id_str = item.id.to_s
    cart.add_item(item.id)
    session[:cart] = cart.contents
    # quantity = session[:cart][item_id_str]
    quantity = cart.contents[item.id.to_s]
    flash[:notice] = "You now have #{pluralize(quantity, "#{item.name}")} in your cart."
    redirect_to "/items"
  end

  def show
    if cart.contents.empty?
      flash[:empty_cart] = "Your cart is empty."
    end
  end

  def delete
    reset_session
    redirect_to "/cart"
  end

  def delete_item
    item = Item.find(params[:item_id])
    session[:cart].delete(item.id.to_s)
    flash[:message] = "You have removed #{item.name} from your cart."
    redirect_to '/cart'
  end

  def decrease
    item = Item.find(params[:item_id])
    session[:cart][item.id.to_s] -= 1
    if cart.contents[item.id.to_s] == 0
      session[:cart].delete(item.id.to_s)
      flash[:message] = "You have removed #{item.name} from your cart."
    else
      flash[:message] = "You have removed a #{item.name} from your cart."
    end
    redirect_to '/cart'
  end

  def increase
    item = Item.find(params[:item_id])
    if (cart.contents[item.id.to_s] + 1) > item.inventory
      flash[:message] = "Sorry, no more #{pluralize(cart.contents[item.id.to_s], "#{item.name}")} can be puchased as this time."
    else
      session[:cart][item.id.to_s] += 1
    end
    redirect_to '/cart'
  end
end
