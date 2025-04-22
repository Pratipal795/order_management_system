class OrdersController < ApplicationController
  def create
    order = Order.find_by(external_id: order_params[:external_id])

    if order
      if order.locked?
        return render json: { error: 'Your Order is Locked For Edit' }, status: 422
      else
        order.line_items.update_all(original: false)
      end
    else
      order = Order.create(external_id: order_params[:external_id], placed_at: order_params[:placed_at])
    end

    RecalculateSkuStatsJob.perform_later(order.line_items.pluck(:sku).uniq)
    render json: { order: order }, status: :ok
  end

  private

  def order_params
    params.permit(:external_id, :placed_at)
  end

  def line_items_params
    params[:line_items] || []
  end
end
