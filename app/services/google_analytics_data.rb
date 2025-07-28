require "google/analytics/data"
require "google/analytics/data/v1beta"

class GoogleAnalyticsData
  # 這邊要記得更換成客戶的 GA4
  GA4_PROPERTY_ID = '469085212'

  def initialize(from: Date.current.at_beginning_of_month,
                 to: 1.day.ago,
                 dimensions: ['date'],
                 metrics: ['totalUsers'])
    # 在開發或是測試時，找不到檔案會觸發 RuntimeError(dashboard_controller.rb:30)，然後用 fake data 取代
    credential_json = "#{Rails.root}/config/google-data-api-credential.json"
    @client = Google::Analytics::Data.analytics_data do |config|
                config.credentials = credential_json
              end

    @from = from
    @to = to
    @dimensions = dimensions.map { |di| Google::Analytics::Data::V1beta::Dimension.new(name: di) }

    # Ref: https://cloud.google.com/php/docs/reference/analytics-data/latest/V1beta.Metric
    @metrics = metrics.map { |mx| Google::Analytics::Data::V1beta::Metric.new(name: mx) }

    date_range = Google::Analytics::Data::V1beta::DateRange.new(
                   start_date: @from.strftime('%Y-%m-%d'),
                   end_date: @to.strftime('%Y-%m-%d')
                 )

    # Ref: https://cloud.google.com/php/docs/reference/analytics-data/latest/V1beta.RunReportRequest
    @request = Google::Analytics::Data::V1beta::RunReportRequest.new(
                 property: "properties/#{GA4_PROPERTY_ID}",
                 dimensions: @dimensions,
                 metrics: @metrics,
                 date_ranges: [date_range]
               )
  end

  def get_report
    # Ref: https://cloud.google.com/php/docs/reference/analytics-data/latest/V1beta.RunReportResponse
    response = @client.run_report(@request)
    data = response.rows.map {|row| [row.dimension_values[0].value, row.metric_values[0].value] }.to_h
    if 'date' == @dimensions.first.name
      (@from..@to).each do |date|
        key = date.strftime('%Y%m%d')
        data[key] = '0' unless data[key].present?
      end
      data.sort.to_h
    else
      data
    end
  end

  # TODO: 可以一次 API 呼叫，執行多個 requests
  # # Ref: https://developers.google.com/analytics/devguides/reporting/data/v1/rest/v1beta/properties/batchRunReports
  # def batch_reports
  #   responses = @client.batch_run_reports(@requests)
  # end
end
