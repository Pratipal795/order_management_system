require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should have_many(:line_items).dependent(:destroy) }
  end

  describe 'validations' do
    subject { described_class.new(external_id: 'SAP-ORDER-1234') }

    it { should validate_presence_of(:external_id) }
    it { should validate_uniqueness_of(:external_id) }
  end

  describe '#locked?' do
    context 'when locked_at is present' do
      it 'returns true' do
        order = described_class.new(locked_at: Time.current)
        expect(order.locked?).to be true
      end
    end

    context 'when created_at is more than 15 minutes ago' do
      it 'returns true' do
        order = described_class.new(created_at: 20.minutes.ago)
        expect(order.locked?).to be true
      end
    end

    context 'when order is fresh and not locked' do
      it 'returns false' do
        order = described_class.new(created_at: Time.current)
        expect(order.locked?).to be false
      end
    end
  end
end
