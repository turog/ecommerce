class CartController < ApplicationController
  
  before_filter :authenticate_user!, only: [:checkout]

  def add_to_cart
  	line_item = LineItem.new
  	line_item.product_id = params[:product_id]
  	line_item.quantity = params[:quantity]
  	line_item.save

  	line_item.line_item_total = line_item.product.price * line_item.quantity
  	line_item.save

  	redirect_to root_path
  end

  def view_order
  	@line_items = LineItem.all
  end

  def checkout
     @line_items = LineItem.all
     @order = Order.new
     @order.user_id = current_user.id

     sum = 0

     @line_items.each do |line_item|
          # this is saying if order item quantity is not there add it to hash if it is increment one more then
         if @order.order_items[line_item.product_id].nil?
              @order.order_items[line_item.product_id] = line_item.quantity
          else
              @order.order_items[line_item.product_id] += line_item.quantity
          end

         sum += line_item.line_item_total
     end

     @order.subtotal = sum
     @order.sales_tax = sum * 0.07
     @order.grand_total = @order.subtotal + @order.sales_tax
     @order.save


     #updating inventory
     @line_items.each do |line_item|
         line_item.product.quantity -= line_item.quantity
         line_item.product.save
     end

     #deleteing cart 
     LineItem.destroy_all

 end

  def current_user_cart
    "cart#{current_user.id}"
  end

 
def order_complete
   @order = Order.find(params[:order_id])
   @amount = (@order.grand_total.to_f.round(2) * 100).to_i

   customer = Stripe::Customer.create(
     :email => current_user.email,
     :card => params[:stripeToken]
   )

   charge = Stripe::Charge.create(
     :customer => customer.id,
     :amount => @amount,
     :description => 'Rails Stripe customer',
     :currency => 'usd'
   )

   rescue Stripe::CardError => e
   flash[:error] = e.message
   redirect_to charges_path
 end
  

end
