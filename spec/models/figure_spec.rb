# == Schema Information
#
# Table name: figures
#
#  id                     :bigint           not null, primary key
#  position(排列順序)     :integer
#  translations           :jsonb
#  imageable_type         :string           not null
#  imageable_id(對象物件) :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_figures_on_imageable  (imageable_type,imageable_id)
#
require 'rails_helper'

RSpec.describe Figure, type: :model do
  # subject { build(:figure) }
  let(:figure) { create(:figure) }

  context 'Validations' do
    it { should validate_presence_of(:image) }
  end

  context "Associations" do
    it { should belong_to(:imageable) }
  end
end
