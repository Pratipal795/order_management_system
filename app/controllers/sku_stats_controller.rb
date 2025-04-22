class SkuStatsController < ApplicationController
  def summary
    stats = SkuStat.where(sku: params[:sku]).order(:week)
    render json: {
      sku: params[:sku],
      summary: stats.map { |s| { week: s.week, total_quantity: s.total_quantity } }
    }
  end
end
