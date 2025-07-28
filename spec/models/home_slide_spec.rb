# == Schema Information
#
# Table name: home_slides
#
#  id                            :bigint           not null, primary key
#  title(標題)                   :text
#  title_en(英文標題)            :text
#  published_at(發布時間)        :datetime
#  published_at_en(英文發布時間) :datetime
#  expired_at(下架時間)          :datetime
#  expired_at_en(英文下架時間)   :datetime
#  slide_type(輪播類型)          :string           default("image"), not null
#  translations                  :jsonb
#  position(排列順序)            :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'rails_helper'

RSpec.describe HomeSlide, type: :model do
  let(:home_slide) { create(:home_slide) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(home_slide).to be_valid
    end

    it { should validate_presence_of(:slide_type) }
    it { should validate_presence_of(:banner) }
    it { should validate_presence_of(:banner_m) }
  end
end
