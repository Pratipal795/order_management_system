class Order < ApplicationRecord
	has_many :line_items, dependent: :destroy
	validates :external_id, presence: true, uniqueness: true

	def locked?
    locked_at.present? || (created_at < 15.minutes.ago)
  end
end
