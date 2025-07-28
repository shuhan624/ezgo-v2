settings = [
  {
    name: 'site_title',
    content_zh_tw: '易齊國際移民 EZGO 全方位移民專家',
    category: 'site'
  },
  {
    name: 'copyright',
    content_zh_tw: '易齊國際移民有限公司',
    category: 'site'
  },
  {
    name: 'gtm',
    category: 'seo'
  },
  {
    name: 'ga',
    category: 'seo'
  },
  {
    name: 'fb_pixel',
    category: 'seo'
  },
  {
    name: 'meta_title',
    content_zh_tw: '易齊國際移民 EZGO 全方位移民專家',
    category: 'seo'
  },
  {
    name: 'meta_keywords',
    content_zh_tw: '易齊, 國際移民, 職業移民, 退休移民',
    category: 'seo'
  },
  {
    name: 'meta_desc',
    content_zh_tw: '易齊國際移民有限公司提供專業合法移民服務，專辦各國投資移民、職業移民、退休移民及台灣移民等業務。陪您實現移民夢想，免費諮詢，為您與家人規劃最佳移民方案，共創美好未來。',
    category: 'seo'
  },
  {
    name: 'og_title',
    content_zh_tw: '易齊國際移民有限公司',
    category: 'seo'
  },
  {
    name: 'og_desc',
    content_zh_tw: '易齊國際移民有限公司提供專業合法移民服務，專辦各國投資移民、職業移民、退休移民及台灣移民等業務。陪您實現移民夢想，免費諮詢，為您與家人規劃最佳移民方案，共創美好未來。',
    category: 'seo'
  },
  {
    name: 'address',
    content_zh_tw: '台北市大安區忠孝東路四段270號17樓',
    category: 'contact'
  },
  {
    name: 'tel',
    content_zh_tw: '+886-2-7707-0699',
    category: 'contact'
  },
  {
    name: 'fax',
    category: 'contact'
  },
  {
    name: 'business_hours',
    content_zh_tw: '週一～週五 10:00~18:00',
    category: 'contact'
  },
  {
    name: 'tax_id_number',
    category: 'contact'
  },
  {
    name: 'email',
    content_zh_tw: 'info@ezgoimmi.com',
    category: 'contact'
  },
  {
    name: 'receivers',
    content_zh_tw: 'serviceinfo@cianwang.com',
    category: 'contact'
  },
  {
    name: 'messenger',
    category: 'contact'
  },
  {
    name: 'popup_homepage',
    category: 'custom',
    status_zh_tw: 'hidden'
  },
  {
    name: 'facebook',
    content_zh_tw: 'https://www.facebook.com/ezgoimmigration',
    status_zh_tw: 'published',
    category: 'social'
  },
  {
    name: 'instagram',
    status_zh_tw: 'hidden',
    category: 'social'
  },
  {
    name: 'linkedin',
    status_zh_tw: 'hidden',
    category: 'social'
  },
  {
    name: 'youtube',
    status_zh_tw: 'hidden',
    category: 'social'
  },
  {
    name: 'line',
    content_zh_tw: 'https://line.me/R/ti/p/@687tdqlp',
    status_zh_tw: 'published',
    category: 'social'
  },
  {
    name: 'admin_logo',
    category: 'logo',
    image: 'logo'
  },
  {
    name: 'logo',
    category: 'logo',
    image: 'logo',
    image_en: 'logo'
  },
  {
    name: 'footer_logo',
    category: 'logo',
    image: 'logo'
  },
  {
    name: 'og_image',
    category: 'logo',
    image: 'logo',
    image_en: 'logo'
  },
  {
    name: 'favicon',
    category: 'logo',
    image: 'favicon',
    image_en: 'favicon'
  },
  {
    name: 'favicon_m',
    category: 'logo',
    image: 'favicon_m',
    image_en: 'favicon_m'
  },
]

settings.each do |item|
  setting = Setting.find_by(name: item[:name])
  if setting.blank?
    setting = Setting.new(
      name: item[:name],
      content_zh_tw: item[:content_zh_tw],
      content_en: item[:content_en],
      status_zh_tw: item[:status_zh_tw],
      status_en: 'hidden',
      category: item[:category],
    )

    if item[:category] == 'logo'
      setting.image.attach(
        io: File.open("#{Rails.root}/public/images/tmp/#{item[:image]}.png"),
        filename: "#{item[:name].dasherize}.png"
      )
      setting.image_en.attach(
        io: File.open("#{Rails.root}/public/images/tmp/#{item[:image_en]}.png"),
        filename: "#{item[:name].dasherize}_en.png"
      ) if item[:image_en].present?
    end

    setting.save
  end
end
