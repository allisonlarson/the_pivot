class Supplier::OrderItemsController < SupplierController
  def increment
    order_item = OrderItem.find(params[:id])
    @order     = Order.find(params[:order_id])
    @order.items << order_item.item
    redirect_to supplier_order_path(@order)
  end

  def decrement
    @order = Order.find(params[:order_id])
    order_item = @order.order_items.find(params[:id])
    order_item.delete if order_item
    redirect_to supplier_order_path(@order)
  end
end
