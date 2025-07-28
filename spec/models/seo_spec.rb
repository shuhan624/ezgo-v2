# == Schema Information
#
# Table name: seos
#
#  id                  :bigint           not null, primary key
#  seoable_type        :string           not null
#  seoable_id          :bigint           not null
#  canonical(標準網址) :string
#  translations        :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_seos_on_seoable  (seoable_type,seoable_id)
#
require 'rails_helper'

RSpec.describe Seo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
