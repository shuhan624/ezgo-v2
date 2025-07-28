require 'rails_helper'

RSpec.describe "Admin Login", type: :system do
  let(:cw_chief) { create(:cw_chief) }

  context "login authentication" do
    let(:default_role) { create(:role, permissions: { article: { index: true }}) }
    let!(:admin) { create(:admin, email: 'admin@example.com', password: 'admin@1234', password_confirmation: 'admin@1234', role: default_role) }

    it "後台管理帳號登入" do
      visit admin_root_path

      fill_in("admin[email]", with: admin.email)
      fill_in("admin[password]", with: admin.password)
      click_button 'commit'
      expect(page).to have_css('aside.sidebar')
    end

    it "沒登入無法看到後台" do
      visit admin_root_path
      expect(page).to_not have_css('aside.sidebar')
    end

    xcontext '前後台兩種帳號處理' do
      let!(:user) { create(:user, :confirmed, email: 'user@example.com', password: 'user@1234', password_confirmation: 'user@1234') }

      it '後台帳號在後台登入後，無法看到前台需登入後看到的畫面' do
        visit admin_root_path
        fill_in("admin[email]", with: admin.email)
        fill_in("admin[password]", with: admin.password)
        click_button 'commit'

        visit 'http://localhost/user/profile'
        expect(page).to have_css('form#new_user')
      end

      it "後台帳號無法登入前台" do
        visit 'http://localhost/login'
        fill_in "user[email]", with: 'admin@example.com'
        fill_in "user[password]", with: 'admin@1234'
        click_button 'commit'

        expect(page).to have_text("電子信箱或密碼錯誤")
        expect(page).to have_css('form#new_user')
      end

      it "前台帳號無法登入後台" do
        visit admin_root_path
        fill_in "admin[email]", with: 'user@example.com'
        fill_in "admin[password]", with: 'user@1234'
        click_button 'commit'
        expect(page).to have_text("帳號或密碼錯誤")
        expect(page).to have_css('form#new_admin')
      end

      it '前台帳號在登入後，無法看到後台內部需登入的畫面' do
        visit 'http://localhost/user/profile'
        fill_in("user[email]", with: user.email)
        fill_in("user[password]", with: user.password)
        click_button 'commit'

        visit admin_articles_path
        expect(page).to have_text("您需要先登入或註冊後才能繼續")
        expect(page).to have_css('form#new_admin')
      end
    end
  end

  context "login passthrough" do
    it "cw_chief 登入後，會到 dashboard" do
      login_as(cw_chief, scope: :admin)
      visit admin_root_path
      expect(page).to have_current_path(admin_dashboard_path)
    end

    context "admin 單一權限登入" do
      let(:admin_role) { create(:role) }
      let(:admin) { create(:admin, role: admin_role) }

      it "沒有任何權限者，會到 404 頁面" do
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_content("404")
      end

      it "有 dashboard_index 權限者，會到 dashboard" do
        admin_role.update(permissions: { dashboard: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_dashboard_path)
      end

      it "有 article_index 權限者，會到 article index" do
        admin_role.update(permissions: { article: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_articles_path)
      end

      it "有 contact_index 權限者，會到 contact index" do
        admin_role.update(permissions: { contact: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_contacts_path)
      end

      it "有 custom_page_index 權限者，會到 custom_page index" do
        admin_role.update(permissions: { custom_page: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_custom_pages_path)
      end

      it "有 faq_index 權限者，會到 faq index" do
        admin_role.update(permissions: { faq: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_faqs_path)
      end

      it "有 article_category_index 權限者，會到 article_category index" do
        admin_role.update(permissions: { article_category: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_article_categories_path)
      end

      it "有 faq_category_index 權限者，會到 faq_category index" do
        admin_role.update(permissions: { faq_category: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_faq_categories_path)
      end

      it "有 partner_index 權限者，會到 partner index" do
        admin_role.update(permissions: { partner: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_partners_path)
      end

      it "有 admin_index 權限者，會到 admin index" do
        admin_role.update(permissions: { admin: { index: true }})
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_admins_path)
      end
    end

    context "Admin 登入時，有多個 Model index 權限" do
      let(:admin_role) { create(:role) }
      let(:admin) { create(:admin, role: admin_role) }

      # 從最後一個index權限開始，每次增加一個 index 權限，測試會去第一個 index 權限的頁面
      it "有 partner_index 權限者，會優先到 partner index" do
        admin_role.update(
          permissions: {
            partner: { index: true },
            admin: { index: true }
          }
        )
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_partners_path)
      end

      it "有 faq_category_index 權限者，會優先到 faq_category index" do
        admin_role.update(
          permissions: {
            faq_category: { index: true },
            partner: { index: true },
            admin: { index: true }
          }
        )
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_faq_categories_path)
      end

      it "有 article_category_index 權限者，會優先到 article_category index" do
        admin_role.update(
          permissions: {
            article_category: { index: true },
            faq_category: { index: true },
            partner: { index: true },
            admin: { index: true }
          }
        )
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_article_categories_path)
      end

      it "有 faq_index 權限者，會優先到 faq index" do
        admin_role.update(
          permissions: {
            faq: { index: true },
            article_category: { index: true },
            faq_category: { index: true },
            partner: { index: true },
            admin: { index: true }
          }
        )
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_faqs_path)
      end

      it "有 custom_page_index 權限者，會到 custom_page index" do
        admin_role.update(
          permissions: {
            custom_page: { index: true },
            faq: { index: true },
            article_category: { index: true },
            faq_category: { index: true },
            partner: { index: true },
            admin: { index: true }
          }
        )
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_custom_pages_path)
      end

      it "有 contact_index 權限者，會到 contact index" do
        admin_role.update(
          permissions: {
            contact: { index: true },
            custom_page: { index: true },
            faq: { index: true },
            article_category: { index: true },
            faq_category: { index: true },
            partner: { index: true },
            admin: { index: true }
          }
        )
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_contacts_path)
      end

      it "有 article_index 權限者，會到 article index" do
        admin_role.update(
          permissions: {
            article: { index: true },
            contact: { index: true },
            custom_page: { index: true },
            faq: { index: true },
            article_category: { index: true },
            faq_category: { index: true },
            partner: { index: true },
            admin: { index: true }
          }
        )
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_articles_path)
      end

      it "有 dashboard_index 權限者，會到 dashboard index" do
        admin_role.update(
          permissions: {
            dashboard: { index: true },
            article: { index: true },
            contact: { index: true },
            custom_page: { index: true },
            faq: { index: true },
            article_category: { index: true },
            faq_category: { index: true },
            partner: { index: true },
            admin: { index: true }
          }
        )
        login_as(admin, scope: :admin)
        visit admin_root_path
        expect(page).to have_current_path(admin_dashboard_path)
      end
    end
  end
end
