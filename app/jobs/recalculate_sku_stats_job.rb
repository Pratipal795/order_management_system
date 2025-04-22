class RecalculateSkuStatsJob < ApplicationJob
  queue_as :default

  def perform(skus)
    skus.uniq.each do |sku|
      last_4_weeks = 4.times.map { |n| (Time.current.beginning_of_week - n.weeks).strftime("%G-W%V") }

      stats = LineItem
        .joins(:order)
        .where(sku: sku, original: true)
        .where(orders: { placed_at: 4.weeks.ago.beginning_of_week..Time.current })
        .select("line_items.*, date_trunc('week', orders.placed_at) as week_date")
        .group_by { |li| li.order.placed_at.strftime("%G-W%V") }

      last_4_weeks.each do |week|
        week_line_items = stats[week] || []
        total = week_line_items.sum(&:quantity)

        stat = SkuStat.find_or_initialize_by(sku: sku, week: week)
        stat.total_quantity = total
        stat.save!
      end
    end
  end
end
