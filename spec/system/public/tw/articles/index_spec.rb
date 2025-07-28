require 'rails_helper'

RSpec.describe "中文版 - 最新消息彙整頁及分類頁", type: :system do
  let(:article) { create(:article) }
  let(:articles_page) { create(:custom_page, slug: 'news') }
  let(:articles_page_with_seo) { create(:custom_page, :with_seo, slug: 'news') }

#   ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌
#  ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀█░█▀▀
#  ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌     ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░▌       ▐░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀
#

  context "主選單語系切換" do
    it '當游標滑入語系切換選單「English」並點選時，可以切換到英文版頁面' do
      articles_page
      visit articles_path
      find('.lang-switch-group').click
      find('.dropdown-list-item', text: 'English').click
      expected_content = find('h1')
      expect(expected_content).to have_content(articles_page.title_en)
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄
#  ▐░░░░░░░░░░░▌▐░▌          ▐░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░▌
#  ▐░▌       ▐░▌▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░▌
#  ▐░░░░░░░░░░░▌▐░▌          ▐░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░▌
#  ▐░▌       ▐░▌▐░▌          ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀
#

  context "最新消息彙整頁" do
    context "麵包屑" do
      it "可以看到麵包屑第一層為「首頁」，並有連結可到中文首頁" do
        articles_page
        visit articles_path
        expected_content = find('.breadcrumb-item', text: '首頁')
        expect(expected_content).to have_link('首頁', href: root_path)
      end

      it "可以看到麵包屑顯示依序為「首頁」>「最新消息自訂頁面標題」" do
        articles_page = create(:custom_page, slug: 'news', title: '最新消息')
        visit articles_path
        breadcrumb_items = all('.breadcrumb-item')

        # 預期的麵包屑順序
        expected_breadcrumbs = ['首頁', '最新消息']

        breadcrumb_items.each_with_index do |item, index|
          expect(item.text).to eq(expected_breadcrumbs[index])
        end
      end
    end

    it "有「最新消息」自訂頁面時，可以看到自訂頁面「標題」，且為「H1」" do
      articles_page
      visit articles_path
      expected_content = find('h1')
      expect(expected_content).to have_content(articles_page.title)
    end

    it "沒有「最新消息」自訂頁面時，可以看到「最新消息」為標題，且為「H1」" do
      visit articles_path
      expected_content = find('h1')
      expect(expected_content).to have_text('最新消息')
    end

    it "可以看到「在發佈期間」的文章" do
      published_article = create(:article, :post_tw, :published_tw)
      visit articles_path
      expect(page).to have_text(published_article.title)
    end

    it "不可以看到「未設定發佈時間」的文章" do
      unpublished_article = create(:article)
      visit articles_path
      expect(page).not_to have_text(unpublished_article.title)
    end

    it "不可以看到「未到發佈時間」的文章" do
      future_article = create(:article, :post_tw, :future_tw)
      visit articles_path
      expect(page).not_to have_text(future_article.title)
    end

    it "不可以看到「已過發佈時間」的文章" do
      expired_article = create(:article, :post_tw, :expired_tw)
      visit articles_path
      expect(page).not_to have_text(article.title)
    end

    context "Meta Data" do
      context "有「最新消息」自訂頁面" do
        context "Meta Title" do
          it "當有輸入時，顯示自訂 Meta Title" do
            articles_page_with_seo
            site_title = Setting.find_by(name: 'site_title').content
            visit articles_path
            expect(page).to have_title("#{articles_page_with_seo.meta_title} | #{site_title}", exact: true)
          end

          it "當未輸入時，顯示自訂頁面的「標題」" do
            articles_page
            site_title = Setting.find_by(name: 'site_title').content
            visit articles_path
            expect(page).to have_title("#{articles_page.title} | #{site_title}", exact: true)
          end
        end

        context "Meta Keywords" do
          it "當有輸入時，顯示自訂 Meta Keywords" do
            articles_page_with_seo
            visit articles_path
            expect(page).to have_meta(:keywords, articles_page_with_seo.meta_keywords)
          end

          it "當未輸入時，顯示全站設定的 Meta Keywords" do
            articles_page
            default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
            visit articles_path
            expect(page).to have_meta(:keywords, default_meta_keywords)
          end
        end

        context "Meta Description" do
          it "當有輸入時，顯示自訂 Meta Description" do
            articles_page_with_seo
            visit articles_path
            expect(page).to have_meta(:description, articles_page_with_seo.meta_desc)
          end

          it "當未輸入時，顯示全站設定的 Meta Description" do
            articles_page
            default_meta_desc = Setting.find_by(name: 'meta_desc').content
            visit articles_path
            expect(page).to have_meta(:description, default_meta_desc)
          end
        end

        context "OG Title" do
          it "當有輸入時，顯示自訂 OG Title" do
            articles_page_with_seo
            visit articles_path
            expect(page).to have_og_meta(:title, articles_page_with_seo.og_title)
          end

          it "當未輸入時，顯示全站設定的 OG Title" do
            articles_page
            default_meta_desc = Setting.find_by(name: 'og_title').content
            visit articles_path
            expect(page).to have_og_meta(:title, default_meta_desc)
          end
        end

        context "OG Description" do
          it "當有輸入時，顯示自訂 OG Description" do
            articles_page_with_seo
            visit articles_path
            expect(page).to have_og_meta(:description, articles_page_with_seo.og_desc)
          end

          it "當未輸入時，顯示全站設定的 Meta Description" do
            articles_page
            default_meta_desc = Setting.find_by(name: 'og_desc').content
            visit articles_path
            expect(page).to have_og_meta(:description, default_meta_desc)
          end
        end
      end

      context "沒有「最新消息」自訂頁面" do
        it "當全站設定有輸入時，顯示全站設定自訂的 Meta Title" do
          site_title = Setting.find_by(name: 'site_title').content
          default_meta_title = Setting.find_by(name: 'meta_title').content
          visit articles_path
          expect(page).to have_title("#{default_meta_title} | #{site_title}", exact: true)
        end

        it "當有全站設定有輸入時，顯示自訂 Meta Keywords" do
          default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
          visit articles_path
          expect(page).to have_meta(:keywords, default_meta_keywords)
        end

        it "當有全站設定有輸入時，顯示自訂 Meta Description" do
          default_meta_desc = Setting.find_by(name: 'meta_desc').content
          visit articles_path
          expect(page).to have_meta(:description, default_meta_desc)
        end

        it "當有全站設定有輸入時，顯示全站設定的「OG Title」" do
          default_og_title = Setting.find_by(name: 'og_title').content
          visit articles_path
          expect(page).to have_og_meta(:title, default_og_title)
        end

        it "當有全站設定有輸入時，顯示全站設定的「OG Description" do
          default_og_desc = Setting.find_by(name: 'og_desc').content
          visit articles_path
          expect(page).to have_og_meta(:description, default_og_desc)
        end
      end
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌          ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context "最新消息分類頁" do
    context "麵包屑" do
      it "可以看到麵包屑第一層為「首頁」，並有連結可到中文首頁" do
        articles_page
        visit articles_path
        expected_content = find('.breadcrumb-item', text: '首頁')
        expect(expected_content).to have_link('首頁', href: root_path)
      end

      it "可以看到麵包屑顯示依序為「首頁」>「最新消息」>「分類名稱」" do
        articles_page = create(:custom_page, slug: 'news', title: '最新消息')
        category = create(:article_category, :published_tw, name: '公告')
        visit cate_articles_path(article_category: category.slug)
        breadcrumb_items = all('.breadcrumb-item')

        # 預期的麵包屑順序
        expected_breadcrumbs = ['首頁', '最新消息', '公告']

        breadcrumb_items.each_with_index do |item, index|
          expect(item.text).to eq(expected_breadcrumbs[index])
        end
      end
    end

    it "可以看到狀態為「公開」的分類頁面，標題為「分類名稱」，且為「H1」" do
      articles_page
      published_category = create(:article_category, :published_tw)
      visit cate_articles_path(article_category: published_category.slug)
      expect(page).to have_content(published_category.name)
    end

    it "不可以看到狀態為「隱藏」的分類頁面" do
      articles_page
      unpublished_category = create(:article_category, :hidden_tw)
      visit cate_articles_path(article_category: unpublished_category.slug)
      expect(page).to have_text('ActiveRecord::RecordNotFound')
    end

    it "可以看到「在發佈期間」且屬於該分類的文章" do
      articles_page
      published_article = create(:article, :post_tw, :published_tw)
      category = published_article.article_categories.first
      visit cate_articles_path(article_category: category.slug)
      expected_content = find('.container .post-items')
      scroll_to(expected_content, align: :top)
      expect(expected_content).to have_text(published_article.title)
    end

    it "不可以看到「在發佈期間」不屬於該分類的文章" do
      articles_page
      create_list(:article_category, 5, :published_tw)
      categories = ArticleCategory.first(3)
      not_target_categories = ArticleCategory.last(2)
      article = create(:article, :post_tw, :published_tw, article_categories: not_target_categories)
      target_category = categories.first

      visit cate_articles_path(article_category: target_category.slug)
      expected_content = find('.container .post-items')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(article.title)
    end

    it "不可以看到「未設定發佈時間」，但屬於該分類的文章" do
      articles_page
      create_list(:article_category, 5, :published_tw)
      categories = ArticleCategory.first(3)
      not_target_categories = ArticleCategory.last(2)
      article = create(:article, :post_tw, article_categories: categories)
      category = article.article_categories.first

      visit cate_articles_path(article_category: category.slug)
      expected_content = find('.container .post-items')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(article.title)
    end

    it "不可以看到「未設定發佈時間」，且不屬於該分類的文章" do
      articles_page
      create_list(:article_category, 5, :published_tw)
      categories = ArticleCategory.first(3)
      not_target_categories = ArticleCategory.last(2)
      article = create(:article, :post_tw, article_categories: categories)
      category = not_target_categories.first

      visit cate_articles_path(article_category: category.slug)
      expected_content = find('.container .post-items')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(article.title)
    end

    it "不可以看到「已過發佈時間」的文章，但屬於該分類的文章" do
      articles_page
      create_list(:article_category, 5, :published_tw)
      categories = ArticleCategory.first(3)
      not_target_categories = ArticleCategory.last(2)
      article = create(:article, :post_tw, :expired_tw, article_categories: categories)
      category = article.article_categories.first

      visit cate_articles_path(article_category: category.slug)
      expected_content = find('.container .post-items')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(article.title)
    end

    it "不可以看到「已過發佈時間」的文章，且不於該分類的文章" do
      articles_page
      create_list(:article_category, 5, :published_tw)
      categories = ArticleCategory.first(3)
      not_target_categories = ArticleCategory.last(2)
      article = create(:article, :post_tw, :expired_tw, article_categories: categories)
      category = not_target_categories.first

      visit cate_articles_path(article_category: category.slug)
      expected_content = find('.container .post-items')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(article.title)
    end

    it "不可以看到「未到發佈時間」的文章，但屬於該分類的文章" do
      articles_page
      create_list(:article_category, 5, :published_tw)
      categories = ArticleCategory.first(3)
      not_target_categories = ArticleCategory.last(2)
      article = create(:article, :post_tw, :future_tw, article_categories: categories)
      category = article.article_categories.first

      visit cate_articles_path(article_category: category.slug)
      expected_content = find('.container .post-items')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(article.title)
    end

    it "不可以看到「未到發佈時間」的文章，且不於該分類的文章" do
      articles_page
      create_list(:article_category, 5, :published_tw)
      categories = ArticleCategory.first(3)
      not_target_categories = ArticleCategory.last(2)
      article = create(:article, :post_tw, :future_tw, article_categories: categories)
      category = not_target_categories.first

      visit cate_articles_path(article_category: category.slug)
      expected_content = find('.container .post-items')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(article.title)
    end

    context "Meta Data" do
      context "Meta Title" do
        it "當有輸入時，顯示自訂 Meta Title" do
          category = create(:article_category, :published_tw, :with_seo)
          site_title = Setting.find_by(name: 'site_title').content
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_title("#{category.meta_title} | #{site_title}", exact: true)
        end

        it "當未輸入時，顯示最新消息分類的「標題」" do
          category = create(:article_category, :published_tw)
          site_title = Setting.find_by(name: 'site_title').content
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_title("#{category.name} | #{site_title}", exact: true)
        end
      end

      context "Meta Keywords" do
        it "當有輸入時，顯示自訂 Meta Keywords" do
          category = create(:article_category, :published_tw, :with_seo)
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_meta(:keywords, category.meta_keywords)
        end

        it "當未輸入時，顯示全站設定的 Meta Keywords" do
          category = create(:article_category, :published_tw)
          default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_meta(:keywords, default_meta_keywords)
        end

        xit "當全站設定未輸入時，顯示網站預設 Meta Keywords" do
          # 目前設定為必填欄位，若改為選填需測試
          category = create(:article_category, :published_tw)
          keywords = Setting.find_by(name: 'meta_keywords')
          keywords.update(content_zh_tw: '')
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_meta(:keywords, '網站建置, 網站開發, 系統開發')
        end
      end

      context "Meta Description" do
        it "當有輸入時，顯示自訂 Meta Description" do
          category = create(:article_category, :published_tw, :with_seo)
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_meta(:description, category.meta_desc)
        end

        it "當未輸入時，顯示全站設定的 Meta Description" do
          category = create(:article_category, :published_tw)
          default_meta_desc = Setting.find_by(name: 'meta_desc').content
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_meta(:description, default_meta_desc)
        end

        xit "當全站設定未輸入時，顯示預設 Meta Description" do
          # 目前設定為必填欄位，若改為選填需測試
          category = create(:article_category, :published_tw)
          desc = Setting.find_by(name: 'meta_desc')
          desc.update(content_zh_tw: '')
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_meta(:description, '網站建置、網站開發、系統開發、客製化網站、網站串接服務、開發內部管理系統。前網數位期望提供您最好的前端網站體驗、最合適與符合現代的網站建置服務，去打造您在線上行銷的完整平台。為您試錯和創造，量身訂製最適合的方案，尋找通往成功的道路。前網數位，您在數位行銷端的關鍵技術夥伴。')
        end
      end

      context "OG Title" do
        it "當有輸入時，顯示自訂 OG Title" do
          category = create(:article_category, :published_tw, :with_seo)
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_og_meta(:title, category.og_title)
        end

        xit "當未輸入時，顯示全站設定的「OG Title」" do
          # 目前設定為必填欄位，若改為選填需測試
          category = create(:article_category, :published_tw)
          og_title = Setting.find_by(name: 'og_title')
          og_title.update(content_zh_tw: '')
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_og_meta(:title, default_og_title)
        end
      end

      context "OG Description" do
        it "當有輸入時，顯示自訂 OG Description" do
          category = create(:article_category, :published_tw, :with_seo)
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_og_meta(:description, category.og_desc(locale: :'zh-TW'))
        end

        xit "當未輸入時，顯示全站設定的「OG Description」" do
          # 目前設定為必填欄位，若改為選填需測試
          category = create(:article_category, :published_tw)
          og_desc = Setting.find_by(name: 'og_desc')
          og_desc.update(content_zh_tw: '')
          visit cate_articles_path(article_category: category.slug)
          expect(page).to have_og_meta(:description, default_og_desc)
        end
      end
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
#   ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌   ▐░▐░▌
#       ▐░▌          ▐░▌     ▐░▌          ▐░▌▐░▌ ▐░▌▐░▌
#       ▐░▌          ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌ ▐░▐░▌ ▐░▌
#       ▐░▌          ▐░▌     ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌
#       ▐░▌          ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌   ▀   ▐░▌
#       ▐░▌          ▐░▌     ▐░▌          ▐░▌       ▐░▌
#   ▄▄▄▄█░█▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌
#  ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌
#   ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀
#

  context "列表項目" do
    it "每一頁不可以看到超過「10」則文章" do
      articles = create_list(:article, 11, :post_tw, :published_tw)
      all_articles = Article.published.order(published_at: :desc)
      article = all_articles[10]
      visit articles_path
      scroll_to(find('.breadcrumb'), align: :top)
      expected_content = find('.post-items')
      expect(expected_content).not_to have_content(article.title)
      expect(expected_content).to have_css('.post-item', count: 10)
    end

    it "當超過「10」則文章時，需看到分頁切換區塊" do
      articles = create_list(:article, 11, :post_tw, :published_tw)
      visit articles_path
      expected_content = find('.base-pagination')
      expect(expected_content).to have_content('1')
      expect(expected_content).to have_content('2')
    end

    it "當未超過「10」則文章時，不可以看到分頁切換區塊" do
      articles = create_list(:article, 10, :post_tw, :published_tw)
      visit articles_path
      scroll_to(find('.post-items'), align: :bottom)
      expect(page).not_to have_css('.base-pagination .pagination')
    end

    it "文章依照發佈日期排序，越近期的日期越上面" do
      article_0101 = create(:article, :post_tw, published_at: '2023-01-01')
      article_0228 = create(:article, :post_tw, published_at: '2023-02-28')
      article_0131 = create(:article, :post_tw, published_at: '2023-01-31')
      visit articles_path
      scroll_to(find('.breadcrumb'), align: :top)
      articles = all('.post-item .post-title')
      expect(articles.count).to eq(3)

      # 預期的文章順序
      expected_articles = [
        article_0228.title,
        article_0131.title,
        article_0101.title,
      ]

      articles.each_with_index do |article_element, index|
        expect(article_element.text).to eq(expected_articles[index])
      end
    end

    it "可以看到「標題」" do
      articles_page
      article = create(:article, :post_tw, :published_tw)
      visit articles_path
      expected_content = find('.container .post-items .post-group .post-title')
      expect(expected_content).to have_content(article.title)
    end

    it "可看到「發布日期」" do
      articles_page
      create(:article, :post_tw, published_at: '2024-01-30').decorate
      visit articles_path
      expected_content = find('.container .post-items .post-group .post-date')
      expect(expected_content).to have_content('2024-01-30')
    end

    context "文章圖片" do
      context "當有設定「代表圖片」" do
        it "可以看到「代表圖片」" do
          articles_page
          article = create(:article, :post_tw, :published_tw, :with_image)
          visit articles_path
          expected_content = find('.container .post-items .imgbox')
          expect(expected_content).to have_xpath("//img[contains(@src,article.image)]")
        end

        it "當有設定「代表圖片 alt」時，可以看到代表圖片 alt 為「自訂的內容」" do
          articles_page
          article = create(:article, :post_tw, :published_tw, :with_image, alt_zh_tw: FFaker::Lorem.characters.first(10))
          visit articles_path
          expected_content = find('.container .post-items .imgbox')
          scroll_to(expected_content, align: :top)
          expect(expected_content).to have_xpath("//img[contains(@alt,article.alt_zh_tw)]")
        end

        it "當未設定「代表圖片 alt」時，可以看到代表圖片 alt 為「文章標題」" do
          articles_page
          article = create(:article, :post_tw, :published_tw, :with_image)
          visit articles_path
          expected_content = find('.container .post-items .imgbox')
          expect(expected_content).to have_xpath("//img[contains(@alt,article.title)]")
        end
      end

      context "當未設定「代表圖片」" do
        it "可以看到「預設圖片」" do
          articles_page
          article = create(:article, :post_tw, :published_tw)
          visit articles_path
          expected_content = find('.container .post-items .imgbox')
          expect(expected_content).to have_xpath("//img[contains(@src, default-img)]")
        end

        it "當有設定「代表圖片 alt」時，可以看到預設圖片 alt 為「自訂的內容」" do
          articles_page
          article = create(:article, :post_tw, :published_tw, alt_zh_tw: FFaker::Lorem.characters.first(10))
          visit articles_path
          expected_content = find('.container .post-items .imgbox')
          scroll_to(expected_content, align: :top)
          expect(expected_content).to have_xpath("//img[contains(@alt,article.alt_zh_tw)]")
        end

        it "當未設定「代表圖片 alt」時，可以看到預設圖片 alt 為「文章標題」" do
          articles_page
          article = create(:article, :post_tw, :published_tw)
          visit articles_path
          expected_content = find('.container .post-items .imgbox')
          expect(expected_content).to have_xpath("//img[contains(@alt,article.title)]")
        end
      end
    end
  end

  context "文章類型" do
    context "文章內容" do
      it "點選「代表圖片」可以看到文章內頁" do
        articles_page
        article = create(:article, :post_tw, :published_tw)
        visit articles_path
        find("img[alt='#{article.title}'").click
        expect(page).to have_content(article.title)
      end

      it "點選「文章標題」可以看到文章內頁" do
        articles_page
        article = create(:article, :post_tw, :published_tw)
        visit articles_path
        post_content = find('.container .post-items .post-group')
        post_content.find('.post-title', text: article.title).click
        expect(page).to have_content(article.title)
      end

      it "從分類頁點擊文章進入內頁時，分類是當前分類，不會是預設分類" do
        articles_page
        category_a = create(:article_category, :published_tw)
        category_b = create(:article_category, :published_tw)
        article = create(:article, :post_tw, :published_tw, default_category: category_a, article_categories: [category_a, category_b])
        visit cate_articles_path(article_category: category_b)
        post_content = find('.container .post-items .post-group')
        post_content.find('.post-title', text: article.title).click
        expect(page.current_path).to eq(article_path(article_category: category_b, id: article.slug))
      end

      it "從不分類頁面點擊文章進入內頁時，分類是預設頁面" do
        articles_page
        category_a = create(:article_category, :published_tw)
        category_b = create(:article_category, :published_tw)
        article = create(:article, :post_tw, :published_tw, default_category: category_a, article_categories: [category_a, category_b])
        visit articles_path
        post_content = find('.container .post-items .post-group')
        post_content.find('.post-title', text: article.title).click
        expect(page.current_path).to eq(article_path(article_category: category_a, id: article.slug))
      end
    end

    context "外部連結" do
      it "點選「代表圖片」可以開啟新分頁" do
        articles_page
        article = create(:article, :link_tw, :published_tw)
        visit articles_path
        find("img[alt='#{article.title}'").click
        within_window(windows.last) do
          expect(page).to have_current_path(article.source_link_zh_tw)
        end
      end

      it "點選「文章標題」可以開啟新分頁" do
        articles_page
        article = create(:article, :link_tw, :published_tw)
        visit articles_path
        post_content = find('.container .post-items .post-group')
        post_content.find('.post-title', text: article.title).click
        within_window(windows.last) do
          expect(page).to have_current_path(article.source_link_zh_tw)
        end
      end
    end
  end
end
