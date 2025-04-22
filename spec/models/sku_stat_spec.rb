require 'rails_helper'

RSpec.describe SkuStat, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:sku) }
    it { should validate_presence_of(:week) }
  end
end
