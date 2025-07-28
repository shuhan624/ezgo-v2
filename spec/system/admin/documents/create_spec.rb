require 'rails_helper'

RSpec.describe "新增單一檔案", type: :system do
  before(:all) do
    @permit_role = create(:role, permissions: {
      document: {
        index: true,
        show: true,
        new: true,
        create: true,
        edit: true,
        update: true,
      }
    })
    @no_create_permit_role = create(:role, permissions: {
      document: {
        index: true,
        show: true,
        new: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_create_permissions_admin = create(:admin, role: @no_create_permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

#   ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
#  ▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
#  ▐░▌▐░▌    ▐░▌▐░▌          ▐░▌       ▐░▌
#  ▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌   ▄   ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌
#  ▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌ ▐░▌░▌ ▐░▌
#  ▐░▌    ▐░▌▐░▌▐░▌          ▐░▌▐░▌ ▐░▌▐░▌
#  ▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌░▌   ▐░▐░▌
#  ▐░▌      ▐░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
#   ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀       ▀▀
#

  context "新增檔案頁面 (new)" do
    it "沒有 new 權限者，不能到達" do
      login_as(@no_permissions_admin, scope: :admin)
      visit new_admin_document_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 new 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit new_admin_document_path
      expect(page).to have_content("新增檔案")
    end

    it "有 new 權限者，可以看到「返回」按鈕，按下「返回」按鈕，可以回到列表頁" do
      login_as(@admin_has_permissions, scope: :admin)
      visit new_admin_document_path
      find('.back-arrow a.btn').click
      expect(page).to have_current_path(admin_documents_path)
      expect(page).to have_text('檔案列表')
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌          ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌     ▐░▌  ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context "新增檔案 (Create)" do
    it "沒有 create 權限者，不能建立" do
      login_as(@no_create_permissions_admin, scope: :admin)
      fill_in_data_on_document_form
      click_button("建立檔案")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 create 權限者，可以建立" do
      login_as(@admin_has_permissions, scope: :admin)
      before_count = Document.count
      fill_in_data_on_document_form
      click_button("建立檔案")

      expected_content = find('section.content')
      title = Document.order(position: :asc).first.title
      after_count = Document.count

      expect(page).to have_content('成功新增 檔案')
      expect(expected_content).to have_content(title)
      expect(after_count).to eq(before_count + 1)
    end
  end

  #   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄       ▄
#  ▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░▌     ▐░▌
#   ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀  ▐░▌   ▐░▌
#       ▐░▌     ▐░▌▐░▌    ▐░▌▐░▌       ▐░▌▐░▌            ▐░▌ ▐░▌
#       ▐░▌     ▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄    ▐░▐░▌
#       ▐░▌     ▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌    ▐░▌
#       ▐░▌     ▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀    ▐░▌░▌
#       ▐░▌     ▐░▌    ▐░▌▐░▌▐░▌       ▐░▌▐░▌            ▐░▌ ▐░▌
#   ▄▄▄▄█░█▄▄▄▄ ▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄  ▐░▌   ▐░▌
#  ▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░▌     ▐░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀  ▀       ▀
#

context "在檔案列表頁" do
  it "有 new 權限者，可以看到「新增」按鈕" do
    login_as(@no_create_permissions_admin, scope: :admin)
    visit admin_documents_path
    expected_content = find('section.content')
    expect(expected_content).to have_content("新增")
  end

  it "沒有 new 權限者，不可以看到「新增」按鈕" do
    login_as(@no_permissions_admin, scope: :admin)
    visit admin_documents_path
    expected_content = find('section.content')
    expect(expected_content).not_to have_content("新增")
  end
end

#   ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄
#  ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#  ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
#  ▐░▌▐░▌ ▐░▌▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀
#

  def fill_in_data_on_document_form
    title = FFaker::Lorem.characters.first(20)
    visit new_admin_document_path

    within('fieldset.radio_buttons.document_file_type') do
      choose('檔案', allow_label_click: true)
    end

    within('fieldset.radio_buttons.document_language') do
      choose('中文', allow_label_click: true)
    end

    fill_in("document[title]", with: title)
    attach_file('document[file]', "#{Rails.root}/spec/fixtures/test.pdf", make_visible: true)
  end
end
