class LineMessage
  def initialize
    @client = Line::Bot::Client.new { |config|
      channel = Rails.application.credentials.line[:messaging_api]
      config.channel_secret = channel[:secret]
      config.channel_token  = channel[:token]
    }
  end

  def push_message(uid, message)
    @client.push_message(uid, message)
  end

  # 群發訊息
  # def group_message(line_ids, message)
  #   @client.multicast(line_ids, message)
  # end
end
