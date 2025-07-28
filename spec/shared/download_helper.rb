require 'rails_helper'

module DownloadHelpers
  TIMEOUT = 1.5
  # 因為 number == 1 的時候，不會有 TEST_ENV_NUMBER,
  # 所以會變成 tmp/downloads, 底下的邏輯會有問題，所以預設給它 1
  number = ENV['TEST_ENV_NUMBER'].presence || '1'
  PATH = Rails.root.join("tmp/downloads", number)

  extend self

  def downloads
    Dir[PATH.join("*")]
  end

  def download
    downloads.first
  end

  def download_content
    wait_for_download
    File.read(download)
  end

  def wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.1 until downloaded?
    end
  end

  def downloaded?
    !downloading? && downloads.any?
  end

  def downloading?
    # .crdownload 是 chrome 下載時的暫存檔名
    downloads.grep(/\.part$/).any? || downloads.grep(/\.crdownload$/).any?
  end

  def clear_downloads
    FileUtils.rm_f(downloads)
  end
end
