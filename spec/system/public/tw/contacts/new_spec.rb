require "rails_helper"

RSpec.describe "聯絡表單 new 頁面", type: :system do
  let!(:contact_page) { create(:custom_page, slug: 'contact') }

  before do
    visit contact_us_path
  end

  it '可以看到 姓名' do
    expect(page).to have_selector('input#contact_name')
  end

  it '可以看到 聯絡信箱' do
    expect(page).to have_selector('input#contact_email')
  end

  it '可以看到 聯絡電話' do
    expect(page).to have_selector('input#contact_phone')
  end

  it '可以看到 詢問內容' do
    expect(page).to have_selector('textarea#contact_content')
  end
end
