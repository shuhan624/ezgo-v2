require 'rails_helper'

RSpec.describe "中文版 - 首頁", type: :system do
  context "近期主打（輪播）" do
    context "發佈狀態" do
      let(:published_slide) { create(:home_slide, :published_tw) }

      it "可以看到「在發佈期間」的輪播圖" do
        published_slide
        visit root_path
        expected_content = find('section.index-banner .swiper-slide-img img')
        expect(expected_content[:src]).to have_content(published_slide.banner.filename.to_s)
      end

      it "不可以看到「未設定發佈時間」的輪播圖" do
        hidden_slide = create(:home_slide)
        visit root_path
        expect(page).not_to have_css('section.index-banner .swiper-slide-img')
      end

      it "不可以看到「未到發佈時間」的輪播圖" do
        future_slide = create(:home_slide, :future_tw)
        visit root_path
        expect(page).not_to have_css('section.index-banner .swiper-slide-img')
      end

      it "不可以看到「已過發佈時間」的輪播圖" do
        expired_slide = create(:home_slide, :expired_tw)
        visit root_path
        expect(page).not_to have_css('section.index-banner .swiper-slide-img')
      end
    end

    context "「在發佈期間」的輪播項目" do
      it "可以看到「圖片」" do
        published_slide = create(:home_slide, :published_tw)
        visit root_path
        expected_content = find('section.index-banner .swiper-slide-img img')
        expect(expected_content[:src]).to have_content(published_slide.banner_m.filename.to_s)
      end

      it "若輪播圖有設定「圖片替代文字」，alt 會看到「圖片替代文字」" do
        published_slide = create(:home_slide, :published_tw, :with_alt)
        visit root_path
        expected_content = find('section.index-banner .swiper-slide-img img')
        expect(expected_content[:alt]).to have_content(published_slide.alt)
      end

      it "若輪播圖沒有設定「圖片替代文字」，alt 會看到「網站名稱」" do
        published_slide = create(:home_slide, :published_tw)
        site_title = Setting.find_by(name: 'site_title').content
        visit root_path
        expected_content = find('section.index-banner .swiper-slide-img img')
        expect(expected_content[:alt]).to have_content(site_title)
      end

      xit "若輪播圖有設定「連結」，點擊會以開啟新分頁方式開啟連結位置" do
        published_slide = create(:home_slide, :published_tw, :with_link)
        visit root_path
        find('section.index-banner .swiper-slide-img').click

        within_window windows.last do
          expect(page).to have_current_path(published_slide.link)
        end

        # 回到原始視窗，避免影響下一個需另開新視窗的測試
        page.driver.browser.close
        switch_to_window(windows.last)
      end
    end

    it "輪播圖片會按照「position」排序 由小到大" do
      slide1 = create(:home_slide, published_at: Time.current - 4.days, position: 1)
      slide2 = create(:home_slide, published_at: Time.current - 2.days, position: 2)
      visit root_path

      expected_contents = find_all('section.index-banner .swiper-slide-img img', count: 2, visible: :all)
      expect(expected_contents[0][:src]).to have_content(slide1.banner.filename.to_s)
      expect(expected_contents[1][:src]).to have_content(slide2.banner.filename.to_s)
    end
  end

  context "最新消息" do
    it "沒有任何一篇公開的文章時，不可以看到最新消息區塊" do
      hidden_article = create(:article)
      visit root_path
      expect(page).not_to have_css('.index-news')
      expect(page).not_to have_css('h2', text: '最新資訊')
    end

    it "文章按照發布日期排序，越晚發布越上面" do
      article_featured_01_01 = create(:article, :post_tw, published_at: '2023-01-01')
      article_featured_02_28 = create(:article, :post_tw, published_at: '2023-02-28')
      article_featured_01_31 = create(:article, :post_tw, published_at: '2023-01-31')

      visit root_path
      expected_content = find('.index-news', visible: false)
      scroll_to(expected_content, align: :top)

      articles = all('.post-item .post-title')
      expect(articles.count).to eq(3)

      # 預期的文章順序
      expected_articles = [
        article_featured_02_28.title,
        article_featured_01_31.title,
        article_featured_01_01.title,
      ]

      articles.each_with_index do |article_element, index|
        expect(article_element.text).to eq(expected_articles[index])
      end
    end

    context "發布狀態" do
      before(:each) do
        @article = create(:article, :published_tw, :post_tw)
      end

      before do
        visit root_path
      end

      it "有任何一篇文章公開時，看到最新消息區塊" do
        expected_content = find('.index-news', visible: false)
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_css('h2', text: '最新資訊')
      end

      it "不可以看到「未設定發佈時間」的文章" do
        hidden_article = create(:article, :post_tw)
        expected_content = find('.index-news', visible: false)
        scroll_to(expected_content, align: :top)
        expect(expected_content).not_to have_content(hidden_article.title)
      end

      it "不可以看到「已過發佈時間」的文章" do
        expired_article = create(:article, :expired_tw, :post_tw)
        expected_content = find('.index-news', visible: false)
        scroll_to(expected_content, align: :top)
        expect(expected_content).not_to have_content(expired_article.title)
      end

      it "不可以看到「未到發佈時間」的文章" do
        future_article = create(:article, :future_tw, :post_tw)
        expected_content = find('.index-news', visible: false)
        scroll_to(expected_content, align: :top)
        expect(expected_content).not_to have_content(future_article.title)
      end
    end

    context "單一文章項目" do
      let(:article) { create(:article, :published_tw, :post_tw) }

      it "可以看到文章「標題」" do
        article
        visit root_path
        scroll_to(find('.index-news', visible: false), align: :top)
        expected_content = find('.index-news .post-title', visible: false)
        expect(expected_content).to have_content(article.title)
      end

      it "可以看到文章「發布日期」" do
        article
        visit root_path
        scroll_to(find('.index-news', visible: false), align: :top)
        expected_content = find('.index-news .post-date-line', visible: false)
        expect(expected_content).to have_content(article.published_at.strftime("%Y-%m-%d"))
      end

      it "可以看到文章「預設分類」" do
        article
        visit root_path
        scroll_to(find('.index-news', visible: false), align: :top)
        expected_content = find('.index-news .post-category', visible: false)
        expect(expected_content).to have_content(article.default_category.name)
      end

      context "文章圖片" do
        context "當有設定「代表圖片」" do
          it "可以看到「代表圖片」" do
            article = create(:article, :published_tw, :post_tw, :with_image)
            visit root_path
            scroll_to(find('.index-news', visible: false), align: :top)
            expected_content = find('.post-item .imgbox', visible: false)
            expect(expected_content).to have_xpath("//img[contains(@src,article.image)]")
          end

          it "當有設定「代表圖片 alt」時，可以看到代表圖片 alt 為「自訂的內容」" do
            article = create(:article, :published_tw, :post_tw, :with_image, :with_image_alt, featured: '1')
            visit root_path
            scroll_to(find('.index-news', visible: false), align: :top)
            expected_content = find('.post-item .imgbox', visible: false)
            expect(expected_content).to have_xpath("//img[contains(@alt,article.alt_zh_tw)]")
          end

          it "當未設定「代表圖片 alt」時，可以看到代表圖片 alt 為「文章標題」" do
            article = create(:article, :published_tw, :post_tw, :with_image)
            visit root_path
            scroll_to(find('.index-news', visible: false), align: :top)
            expected_content = find('.post-item .imgbox', visible: false)
            expect(expected_content).to have_xpath("//img[contains(@alt,article.title)]")
          end
        end

        context "當未設定「代表圖片」" do
          it "可以看到「預設圖片」" do
            article = create(:article, :published_tw, :post_tw)
            visit root_path
            scroll_to(find('.index-news', visible: false), align: :top)
            expected_content = find('.post-item .imgbox', visible: false)
            expect(expected_content).to have_xpath("//img[contains(@src, default-img)]")
          end

          it "當有設定「代表圖片 alt」時，可以看到預設圖片 alt 為「自訂的內容」" do
            article = create(:article, :published_tw, :post_tw, :with_image_alt, featured: '1')
            visit root_path
            scroll_to(find('.index-news', visible: false), align: :top)
            expected_content = find('.post-item .imgbox', visible: false)
            expect(expected_content).to have_xpath("//img[contains(@alt,article.alt_zh_tw)]")
          end

          it "當未設定「代表圖片 alt」時，可以看到預設圖片 alt 為「文章標題」" do
            article = create(:article, :published_tw, :post_tw)
            visit root_path
            scroll_to(find('.index-news', visible: false), align: :top)
            expected_content = find('.post-item .imgbox', visible: false)
            expect(expected_content).to have_xpath("//img[contains(@alt,article.title)]")
          end
        end
      end
    end

    context "文章類型" do
      context "文章內容" do
        before(:each) do
          @article = create(:article, :published_tw, :post_tw)
          @category = @article.default_category
          @slug = @article.slug
        end

        before do
          visit root_path
          scroll_to(find('.index-news', visible: false), align: :top)
        end

        it "點選「代表圖片」可以看到文章內頁" do
          find("img[alt='#{@article.title}'").click
          expect(page).to have_current_path(article_path(article_category: @category, id: @slug))
          expect(page).to have_content(@article.title)
        end

        it "點選「文章標題」可以看到文章內頁" do
          find('.post-title', text: @article.title).click
          expect(page).to have_current_path(article_path(article_category: @category, id: @slug))
          expect(page).to have_content(@article.title)
        end

        it "點選「預設分類」可以看到文章內頁" do
          find('.post-category', text: @category.name).click
          expect(page).to have_current_path(article_path(article_category: @category, id: @slug))
          expect(page).to have_content(@article.title)
        end

        it "點選「發布日期」可以看到文章內頁" do
          find('.post-date-line', text: @article.published_at.strftime("%Y-%m-%d")).click
          expect(page).to have_current_path(article_path(article_category: @category, id: @slug))
          expect(page).to have_content(@article.title)
        end
      end

      context "外部連結" do
        before(:each) do
          @article = create(:article, :published_tw, :link_tw)
          @category = @article.default_category
          @slug = @article.slug
        end

        before do
          visit root_path
          scroll_to(find('.index-news', visible: false), align: :top)
        end

        it "點選「代表圖片」可以開啟新分頁到設定的網址" do
          find("img[alt='#{@article.title}'").click
          within_window(windows.last) do
            expect(page).to have_current_path(@article.source_link_zh_tw)
          end
        end

        it "點選「文章標題」可以開啟新分頁到設定的網址" do
          find('.post-title', text: @article.title).click
          within_window(windows.last) do
            expect(page).to have_current_path(@article.source_link_zh_tw)
          end
        end

        it "點選「預設分類」可以開啟新分頁到設定的網址" do
          find('.post-category', text: @category.name).click
          within_window(windows.last) do
            expect(page).to have_current_path(@article.source_link_zh_tw)
          end
        end

        it "點選「發布日期」可以開啟新分頁到設定的網址" do
          find('.post-date-line', text: @article.published_at.strftime("%Y-%m-%d")).click
          within_window(windows.last) do
            expect(page).to have_current_path(@article.source_link_zh_tw)
          end
        end
      end
    end
  end

  context "Meta Data" do
    before do
      visit root_path
    end

    context "Meta Title" do
      it "當全站設定的「Meta 標題」有輸入時，顯示全站設定的「Meta 標題」" do
        meta_title = Setting.find_by(name: 'meta_title').content
        expect(page).to have_title(meta_title, exact: true)
      end
    end

    it "當全站設定有輸入時，顯示自訂 Meta Keywords" do
      default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
      expect(page).to have_meta(:keywords, default_meta_keywords)
    end

    it "當全站設定有輸入時，顯示自訂 Meta Description" do
      default_meta_desc = Setting.find_by(name: 'meta_desc').content
      expect(page).to have_meta(:description, default_meta_desc)
    end

    it "當有全站設定有輸入時，顯示全站設定的「OG Title」" do
      default_og_title = Setting.find_by(name: 'og_title').content
      expect(page).to have_og_meta(:title, default_og_title)
    end

    it "當有全站設定有輸入時，顯示全站設定的「OG Description" do
      default_og_desc = Setting.find_by(name: 'og_desc').content
      expect(page).to have_og_meta(:description, default_og_desc)
    end
  end
end
