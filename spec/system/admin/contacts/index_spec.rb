require 'rails_helper'

RSpec.describe "聯絡表單管理", type: :system do
  let(:contact) { create(:contact) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      contact: {
        index: true,
      }
    })
    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌     ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀
#            ▐░▌     ▐░▌     ▐░▌       ▐░▌▐░▌
#   ▄▄▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀
#

  context "在側邊欄中的聯絡表單項目" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).not_to have_text('聯絡表單')
    end

    it "有 index 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).to have_text('聯絡表單')
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

  context "聯絡表單列表 (index)" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_contacts_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 index 權限者，可以看到" do
      contact
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_contacts_path
      expect(page).to have_text(contact.name)
    end
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    it "可以看到搜尋區塊" do
      visit admin_contacts_path
      expect(page).to have_css('.index-search-form')
    end

    it "聯絡表單項目依照「填寫日期」排序，填寫日期越晚越上面" do
      contact_1 = create(:contact, created_at: '2025-01-01 00:00:00')
      contact_3 = create(:contact, created_at: '2025-01-03 00:00:00')
      contact_2 = create(:contact, created_at: '2025-01-02 00:00:00')
      visit admin_contacts_path
      contacts = all('tr.contact td.column-primary')
      expect(contacts.count).to eq(3)

      # 預期的分類順序
      expected_contacts = [contact_3.name, contact_2.name, contact_1.name]

      contacts.each_with_index do |contact_element, index|
        expect(contact_element.text).to eq(expected_contacts[index])
      end
    end
  end

  context "列表項目" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    let!(:contact) { create(:contact) }

    it "可以看到「名稱」" do
      visit admin_contacts_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(contact.name)
    end

    it "可以看到「Email」" do
      visit admin_contacts_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(contact.email)
    end

    it "可以看到「摘要」" do
      visit admin_contacts_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(contact.decorate.summary)
    end

    it "可以看到「填寫日期」" do
      visit admin_contacts_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(contact.created_at.strftime('%Y/%m/%d %H:%M'))
    end

    it "可以看到「更新於」" do
      visit admin_contacts_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(contact.updated_at.strftime('%Y/%m/%d %H:%M'))
    end

    it "可以看到「狀態」" do
      visit admin_contacts_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(I18n.t("simple_form.options.contact.status.#{contact.status}"))
    end
  end

  context "按鈕區塊" do
    let(:index_permission_role) { create(:role, permissions: {
      contact: { index: true }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      contact: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      contact: { index: true, show: true, edit: true }
    }) }

    let(:index_permission_admin) { create(:admin, role: index_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let!(:contact) { create(:contact) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_contacts_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_contacts_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_contacts_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_contacts_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).to have_content(I18n.t('btn.edit'))
        end
      end
    end

    context "刪除按鈕 (destroy)" do
      it "不可以看到刪除按鈕" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_contacts_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌▐░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌ ▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌
#   ▀            ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀
#

  context "分頁區塊" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "未超過「25」筆資料" do
      before(:all) do
        @contacts = create_list(:contact, 25)
      end

      after(:all) do
        Contact.delete_all
      end

      before do
        visit admin_contacts_path
      end

      it "可以看到共有幾筆資料" do
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('顯示 25 筆')
      end

      it "不可以看到分頁切換按鈕" do
        expect(page).not_to have_css('.pagination')
      end
    end

    context "超過「25」筆資料" do
      before(:all) do
        @contacts = create_list(:contact, 26)
      end

      after(:all) do
        Contact.delete_all
      end

      before do
        visit admin_contacts_path
      end

      it "可以看到共有幾筆資料" do
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "每一頁不可以看到超過「25」筆資料" do
        contact = Contact.order(created_at: :desc).last # 取得第 26 筆資料
        scroll_to(find('table'), align: :bottom)
        expected_content = find('table')
        expect(expected_content).not_to have_content(contact.name)
        expect(expected_content).to have_css('tr.contact', count: 25)
      end

      it "需看到分頁切換按鈕" do
        scroll_to(find('table'), align: :bottom)
        expect(page).to have_css('.pagination')
      end

      it "按下「指定分頁」按鈕，可以看到指定的分頁頁面" do
        within '.pagination' do
          click_link '2'
        end
        expect(page).to have_current_path(admin_contacts_path(page: 2))
        expect(page).to have_content('共 26 筆，顯示 26 - 26 筆')
      end

      it "按下「下一頁」按鈕，可以看到目前分頁的下一頁頁面" do
        within '.pagination' do
          find('.next').click
        end
        expect(page).to have_content('共 26 筆，顯示 26 - 26 筆')
      end

      it "按下「上一頁」按鈕，可以看到目前分頁的上一頁頁面" do
        within '.pagination' do
          find('.next').click
          find('.prev').click
        end
        expect(page).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "當在第一頁時，「上一頁」按鈕，不可以點選" do
        expect(page).to have_selector('.pagination .prev.disabled', text: '‹')
      end

      it "當在最後一頁時，「下一頁」按鈕，不可以點選" do
        within '.pagination' do
          find('.next').click
        end
        expect(page).to have_selector('.pagination .next.disabled', text: '›')
      end
    end
  end
end
