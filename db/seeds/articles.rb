article_categories = [
  {
    name: '移民公告',
    name_en: 'Announcement',
  },
  {
    name: '外僑學校',
    name_en: 'International Schools',
  }
]

article_categories.each do |item|
  article_category = ArticleCategory.find_by(name: item[:name])
  if article_category.blank?
    article_category = ArticleCategory.new(
      name: item[:name],
      name_en: item[:name_en],
      slug: item[:name_en].downcase.parameterize(separator: '-'),
      status: 'published',
    )
    article_category.save
  end
end

articles = [
  {
    title: '馬爾他投資永久居留計劃 MPRP 最新數據',
    slug: 'malta-permanent-residence-program-mprp-latest-statistics',
    default_category_id: ArticleCategory.find_by(name: '移民公告').id,
    article_category_ids: ArticleCategory.where(name: %w[移民公告]).ids,
    published_at: '2025-04-08 11:22',
    post_type: 'post',
    content: '<p>根據馬爾他投資永久居留計劃 MPRP 截至 2024 年第三季度的數據，以下是申請統計資訊：</p><ul><li>申請總量（2016 - 2022年）：3,580 份</li><li>核准率：71%</li><li>拒簽率：10%</li><li>撤案率：3%</li><li>正在處理中：16%</li></ul><p>另外，2022 年單年申請量達到 780 份，顯示出馬爾他作為移民目的地的強大吸引力。 （資料來源於馬爾他政府統計資料）</p>'
  },
  {
    title: '美國 2025 年 4 月簽證排期 表A & 表B',
    slug: 'usa-visa-deadline-for-april-2025',
    default_category_id: ArticleCategory.find_by(name: '移民公告').id,
    article_category_ids: ArticleCategory.where(name: %w[移民公告]).ids,
    published_at: '2025-04-07 11:49',
    post_type: 'post',
    content: '<p>4 月份職業移民排期與上月相比有些變化，具體數據請看圖片內容。</p><p><strong>根據排期表A（Final Action Dates）審批排期，對於台灣出生的申請人來說：</strong></p><ul><li>EB-1 無排期。</li><li>EB-2 排期為2023年06月22日，前進一個月。</li><li>EB-3 排期為2023年01月01日，前進一個月。</li><li>EB-5 投資移民 (直投和區域中心)，無排期。</li><li>投資移民 (新政預留三類：鄉村、高失業地區、基建) 無排期。</li></ul><p>&nbsp;</p><p><strong>根據排期表B（Dates for Filing）遞件排期，對於台灣出生的申請人來說：</strong></p><ul><li>EB-1 無排期。</li><li>EB-2 排期為2023年08月01日，無變動。</li><li>排期為2023年03月01日，無變動。</li><li>EB-5 投資移民 (直投和區域中心) 無排期。</li><li>EB-5 投資移民 (新政預留三類：鄉村、高失業地區、基建) 無排期。</li></ul><p>圖片註解：</p><ul><li>1st：傑出人才、傑出教授或研究人員、跨國公司高級主管或經理。</li><li>2nd：擁有研究生以上學歷的專業人員，以及在藝術、科學或商業領域具特殊能力的人才。</li><li>3rd：擁有本科學歷的專業人員和技術人員。 Other Workers：非技術勞工。</li><li>4th：特殊人員。 Certain Religious Workers：宗教人士。</li><li>5th：EB&minus;5投資移民；Unreserved 對應未特別保留簽證名額的類別，包含依據舊法遞交的申請，Set Aside 即對應新法三類保留簽證名額的情況。</li></ul><p>資料來源：<a href="https://travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin/2025/visa-bulletin-for-april-2025.html" target="_blank" rel="noopener">https://travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin/2025/visa-bulletin-for-april-2025.html</a>（發佈日期2025/3/31）</p>'
  },
  {
    title: '2025 加拿大家庭護理移民試點項目開放申請！',
    slug: 'applications-for-the-2025-canadian-family-caregiver-immigration-pilot-program-are-open',
    default_category_id: ArticleCategory.find_by(name: '移民公告').id,
    article_category_ids: ArticleCategory.where(name: %w[移民公告]).ids,
    published_at: '2025-03-25 11:49',
    post_type: 'post',
    content: '<p>想移民加拿大嗎？最新的家庭護理移民試點項目於 2025 年正式推出！這次的改動讓申請更加簡單，符合條件的你可以一步到位，直接申請加拿大永久居民（PR）身份！</p><p>&nbsp;</p><p><strong>新政策分類：</strong></p><ol><li>加拿大境內工簽持有人</li><li>境外申請人</li></ol><p>&nbsp;</p><p><strong>申請時間：</strong></p><ul><li>3月31日，首批申請將開放給加拿大境內的工簽持有人申請，境外申請者需等待後續公告。</li></ul><p>&nbsp;</p><p><strong>新政策重點：</strong></p><ol><li>一步到位申請永居身份。</li><li>降低語言和教育要求：英語達到 CLB 4 級與高中以上學歷。</li><li>無需加拿大工作經驗：申請人不需要有加拿大工作經驗。但需要具有近期的相關工作經驗，或完成至少 6 個月的相關家庭護理培訓，並且需要在加拿大魁省以外的地區獲得全職家庭護理工作機會 Job Offer。</li><li>提供彈性的工作選擇與工作機會：家庭照顧者可以在需要的地方工作。工作機會可以來自：<ol><li>私人家庭雇主</li><li>為半獨立或正從受傷或生病中恢復的人提供短期或偶爾家庭護理的組織：<ol><li>家庭健康服務提供者。</li><li>居家照護支援服務提供者。</li><li>直接護理機構（為老年人或殘障或慢性病患提供個人護理服務之機構）。</li><li>住宅環境中的個人護理服務。</li><li>兒科家庭保健服務提供者。</li></ol></li></ol></li></ol><p><strong>申請條件：</strong></p><ol><li>語言要求：CLB 4（說4.0、聽4.5、讀3.5、寫4.0）。</li><li>學歷要求：高中及以上學歷。</li><li>工作經驗或培訓：相關的家庭護理工作經驗或完成至少 6 個月的培訓。</li><li>加拿大全職工作聘書（Job Offer）：需要在魁省以外的地區獲得家庭護理相關工作機會。</li></ol><p>（資料來源於外電綜合報導，發佈日期 2025/3/24）</p>'
  },
  {
    title: '馬來西亞我的第二家園計劃 MM2H 最新動態',
    slug: 'malaysia-my-second-home-program-mm2h-latest-news',
    default_category_id: ArticleCategory.find_by(name: '移民公告').id,
    article_category_ids: ArticleCategory.where(name: %w[移民公告]).ids,
    published_at: '2025-03-20 11:49',
    post_type: 'post',
    content: '<p>根據馬來西亞旅遊、藝術和文化部長張建聲（Datuk Seri Tiong King Sing）於今年 2 月 24 日的國會書面回應，截至 2024 年 12 月，馬來西亞我的第二家園計劃 MM2H 在新政策下共核准782份申請，其中 319 名為主申請人，463 名為附屬申請人。</p><p>同時也提到在舊政策下，MM2H 計劃已累積獲得 57,686 份核准，涵蓋 28,209 名主申請人和 29,477 名附屬申請人。</p><p>另外，根據申請和核准數量，馬來西亞我的第二家園計劃MM2H的五個主要國家分別是：</p><ol><li>中國</li><li>韓國</li><li>日本</li><li>孟加拉國</li><li>英國</li></ol><p>（資料來源於外媒綜合報導）</p>'
  },
  {
    title: '美國移民 3/15 線上說明會',
    slug: 'usa-immigration-online-information-session-march-15',
    default_category_id: ArticleCategory.find_by(name: '外僑學校').id,
    article_category_ids: ArticleCategory.where(name: %w[外僑學校]).ids,
    published_at: '2025-03-01 11:49',
    post_type: 'post',
    content: '<p>已更新：3月3日</p><p><strong>提供您優質的移民途徑</strong></p><p><span style="background-color: rgb(251, 238, 184);">時間：3/15 星期六 下午 1:30-3:00 免費入場</span></p><ul><li>多位移民專家親蒞</li><li>全面解析移民方式</li></ul><p><span style="background-color: rgb(251, 238, 184);">報名連結：<a href="https://forms.gle/DCVmn43Dgs6GYgY6A" target="_blank" rel="noopener">https://forms.gle/DCVmn43Dgs6GYgY6A</a></span></p><p>也可以加入易齊移民 <a href="https://line.me/R/ti/p/@687tdqlp?oat_content=url&amp;ts=02271620" target="_blank" rel="noopener">LINE 官方</a>，由專人為您服務：<a href="https://lin.ee/74UhBzVT" target="_blank" rel="noopener">https://lin.ee/74UhBzVT</a></p><p>或拿起電話，立即報名！</p>'
  },
]

articles.each do |item|
  article = Article.find_by(title: item[:title])
  if article.blank?
     article = Article.new(
      title: item[:title],
      slug: item[:slug],
      default_category_id: item[:default_category_id],
      article_category_ids: item[:article_category_ids],
      published_at: item[:published_at],
      post_type: item[:post_type],
      abstract_zh_tw: item[:abstract_zh_tw],
      content: item[:content],
    )

    article.image.attach(
      io: File.open(File.join(Rails.root, "public/images/tmp/default-image.jpg")),
      filename: "default-image.jpg"
    )

    article.save
  end
end
