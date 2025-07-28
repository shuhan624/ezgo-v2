class Admin::DashboardController < AdminController
  def index
    authorize :dashboard, :index?
  end

  def marketing
    authorize :dashboard, :marketing?
    @date_range = if params[:date_range].present?
                   from, to = params[:date_range].split(' ~ ')
                   (Date.parse(from)..Date.parse(to))
                 else
                   (7.days.ago.to_date..Date.yesterday)
                 end
    @date_range_str = @date_range.first.strftime('%F') + ' ~ ' + @date_range.last.strftime('%F')
    @x = @date_range.map { |date| date.strftime('%m-%d') }.unshift('x')

    # Chart #1 每日到訪人數
    @daily_users = daily_users_report.map { |date, value| value }.unshift('dailyUsers')

    @previous_period = previous_period_report.map { |date, value| value }.unshift('previousPeriod') if params[:compare].present? && 'true' == params[:compare]

    # Chart #2 流量來源
    sources = sources_report
    @sources_data = sources
    @source_total = sources.to_h.values.inject(0) { |sum, s| sum + s.to_i }

    # Chart #3 頁面瀏覽
    @pv_data = pageviews_report
    @pageviews = @pv_data.map { |s| s['page'] }
  rescue RuntimeError => e
    # fake data
    @daily_users = @x.drop(1).each_with_index.map { |date, i| (i*100) + rand(4000..5000) }.unshift('dailyUsers')
    @sources_data = %w(Google Bing 直接 Facebook Social).map { |s| [s, rand(10..300)] }
    @source_total = "#{@sources_data.to_h.values.sum}K"

    pageviews = %w(首頁/ /team /contact).map { |s| [s, rand(10..300)] }.to_h.sort_by { |key, value| value.to_i }.reverse.to_h
    @pv_data = pageviews.map { |k, v| { 'page' => k, k => v } }
    @pageviews = @pv_data.map { |s| s['page'] }
  end


  private

  def daily_users_report
    ga_users = GoogleAnalyticsData.new(from: @date_range.first, to: @date_range.last)
    ga_users.get_report
  end

  def previous_period_report
    previous_period = ((@date_range.first - @date_range.count)..(@date_range.first - 1))
    previous_ga = GoogleAnalyticsData.new(from: previous_period.first, to: previous_period.last)
    previous_ga.get_report
  end

  def sources_report
    ga_sources = GoogleAnalyticsData.new(
                   from: @date_range.first,
                   to: @date_range.last,
                   dimensions: ['firstUserSource'],
                   metrics: ['activeUsers']
                 )
    data = ga_sources.get_report # Hash
    data = data.map { |k, v| [( (k == '(direct)') ? '直接' : k ), v.to_i] } # Array
    n = 1
    others = 0
    data.each do |source|
      n += 1
      next if n < 10
      others += source.last
    end
    data = data.first(9)
    data << ['其他', others]
    data
  end

  def pageviews_report
    ga_pageviews = GoogleAnalyticsData.new(
                   from: @date_range.first,
                   to: @date_range.last,
                   dimensions: ['pagePath'],
                   metrics: ['screenPageViews']
                 )
    data = ga_pageviews.get_report
    pageviews = data.sort_by { |key, value| value.to_i }.reverse.first(7).to_h
    pageviews.map { |k, v| { 'page' => (k == '/' ? '首頁 /' : k), (k == '/' ? '首頁 /' : k) => v } }
  end
end
