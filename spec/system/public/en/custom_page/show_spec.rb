require 'rails_helper'

RSpec.describe "英文版 - 自訂頁面內頁", type: :system do
  context "網址" do
    it "可以訪問公開的自訂頁面" do
      custom_page = create(:custom_page, :published_en)
      visit "http://localhost/en/#{custom_page.slug}"
      expect(page).to have_content(custom_page.title_en)
    end

    it "無法訪問未公開的自訂頁面" do
      custom_page = create(:custom_page, :hidden_en)
      visit "http://localhost/en/#{custom_page.slug}"

      # Selenium 不支援 page.status_code，因此檢查頁面內容
      expect(page).to have_content('ActiveRecord::RecordNotFound')
    end
  end

  context "內容" do
    it "可以看到「英文標題」，且為「H1」" do
      custom_page = create(:custom_page, :published_en)
      visit custom_page_path(custom_page.slug)
      expected_content = find('h1')
      expect(expected_content).to have_content(custom_page.title_en)
    end

    it "可以看到「英文文章內容」" do
      custom_page = create(:custom_page, :published_en, :info)
      visit custom_page_path(custom_page.slug)
      expected_content = find('.container .custom-editor')
      expect(expected_content).to have_content(custom_page.content_en)
    end
  end

  context "Meta Data" do
    context "Meta Title" do
      it "當有輸入時，顯示自訂 Meta Title" do
        site_title = Setting.find_by(name: 'site_title').content
        custom_page = create(:custom_page, :published_en, :with_seo)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_title("#{custom_page.meta_title} | #{site_title}", exact: true)
      end

      it "當未輸入時，顯示最新消息「標題」" do
        site_title = Setting.find_by(name: 'site_title').content
        custom_page = create(:custom_page, :published_en)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_title("#{custom_page.title_en} | #{site_title}", exact: true)
      end
    end

    context "Meta Keywords" do
      it "當有輸入時，顯示自訂 Meta Keywords" do
        site_title = Setting.find_by(name: 'site_title').content
        custom_page = create(:custom_page, :published_en, :with_seo)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_meta(:keywords, custom_page.meta_keywords)
      end

      it "當未輸入時，顯示網站預設 Meta Keywords" do
        default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
        custom_page = create(:custom_page, :published_en)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_meta(:keywords, default_meta_keywords)
      end
    end

    context "Meta Description" do
      it "當有輸入時，顯示自訂 Meta Description" do
        site_title = Setting.find_by(name: 'site_title').content
        custom_page = create(:custom_page, :published_en, :with_seo)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_meta(:description, custom_page.meta_desc)
      end

      it "當未輸入時，顯示預設 Meta Description" do
        default_meta_desc = Setting.find_by(name: 'meta_desc').content
        custom_page = create(:custom_page, :published_en)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_meta(:description, default_meta_desc)
      end
    end

    context "OG Title" do
      it "當有輸入時，顯示自訂 OG Title" do
        custom_page = create(:custom_page, :published_en, :with_seo)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_og_meta(:title, custom_page.og_title)
      end

      it "當未輸入時，顯示全站設定的「OG Title」" do
        default_og_title = Setting.find_by(name: 'og_title').content
        custom_page = create(:custom_page, :published_en)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_og_meta(:title, default_og_title)
      end
    end

    context "OG Description" do
      it "當有輸入時，顯示自訂 OG Description" do
        custom_page = create(:custom_page, :published_en, :with_seo)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_og_meta(:description, custom_page.og_desc)
      end

      it "當未輸入時，顯示全站設定的「OG Description" do
        default_og_desc = Setting.find_by(name: 'og_desc').content
        custom_page = create(:custom_page, :published_en)
        visit custom_page_path(custom_page.slug)
        expect(page).to have_og_meta(:description, default_og_desc)
      end
    end

    context "canonical url" do
      it "canonical 為自訂頁面網址: host/:slug" do
        custom_page = create(:custom_page, :published_en)
        visit custom_page_path(custom_page.slug)

        link_with_port = find('link[rel="canonical"]', visible: false)[:href]
        # 將 port 移除(把冒號後面的數字替換為空字串)
        canonical_link = link_with_port.sub(/:\d+/, '')

        expect(canonical_link).to eq(custom_page_url(custom_page.slug))
      end
    end
  end
end
