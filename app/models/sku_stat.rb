class SkuStat < ApplicationRecord
	validates :sku, :week, presence: true
end
