slides = [
  {
    title: '易齊國際移民 陪您一起移民',
    desc: '接軌世界 夢想啟程'
  },
]

slides.each do |item|
  slide = HomeSlide.find_by(title: item[:title])
  if slide.blank?
    slide = HomeSlide.new(
      title: item[:title],
      desc: item[:desc],
      published_at: Time.current,
    )
  end

  slide.banner.attach(
    io: File.open('public/images/banner/banner-1920x600.jpg'),
    filename: "banner-1920x600.jpg"
  )

  slide.banner_m.attach(
    io: File.open('public/images/banner/banner-1080x1500.jpg'),
    filename: "banner-1920x600.jpg"
  )

  slide.save
end
