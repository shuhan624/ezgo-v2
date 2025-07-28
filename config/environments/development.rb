require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing.
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.asset_host = 'http://localhost:3000'

  mail_setting = Rails.application.credentials.smtp || {}
  config.action_mailer.delivery_method = :smtp

  # SMTP settings for Google Workspace / Gmail
  config.action_mailer.smtp_settings = {
    address: mail_setting[:server] || 'smtp.gmail.com',
    port: 587,
    domain: mail_setting[:domain] || 'gmail.com',
    user_name: mail_setting[:user_name] || 'test@gmail.com',
    password: mail_setting[:password] || '123',
    authentication: :plain,
    enable_starttls_auto: true
  }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Disable caching for Action Mailer templates even if Action Controller
  # caching is enabled.
  config.action_mailer.perform_caching = false
  config.action_mailer.preview_paths << "#{Rails.root}/test/mailers/previews"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  config.hosts << "admin.lvh.me"
  config.hosts << "www.lvh.me"

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  class DevLogFormatter
    def initialize
      # Suppress is an array of request uuids. Each listed uuid means no messages from this request.
      @suppress = []
    end

    def call(severity, datetime, progname, message)
      # Get uuid, which we need to properly distinguish between parallel requests.
      # Also remove uuid information from log (that's why we match the rest of message)
      matches = /\[([0-9a-zA-Z\-_]+)\] (.*)/m.match(message)

      if matches
        uuid = matches[1]
        message = matches[2]

        if @suppress.include?(uuid) && message.start_with?("Completed ")
          # Each request in Rails log ends with "Completed ..." message, so do suppressed messages.
          @suppress.delete(uuid)
          return nil

        elsif message.start_with?("Processing by ActiveStorage::DiskController#show", "Processing by ActiveStorage::BlobsController#show", "Processing by ActiveStorage::RepresentationsController#show", "Started GET \"/rails/active_storage/disk/", "Started GET \"/rails/active_storage/blobs/", "Started GET \"/rails/active_storage/representations/")
          # When we use ActiveStorage disk provider, there are three types of request: Disk requests, Blobs requests and Representation requests.
          # These three types we would like to hide.
          @suppress << uuid
          return nil

        elsif !@suppress.include?(uuid)
          # All messages, which are not suppressed, print. New line must be added here.
          return "#{message}\n"
        end

      else
        # Return message as it is (including new line at the end)
        return "#{message}\n"
      end

    end
  end

  config.log_tags = [:uuid]
  config.log_formatter = DevLogFormatter.new

  config.after_initialize do
    Bullet.enable        = true
  # Bullet.alert         = true
  # Bullet.bullet_logger = true
    Bullet.console       = true
  # Bullet.growl         = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
    Bullet.add_safelist type: :unused_eager_loading, class_name: 'ActiveStorage::Attachment', association: :blob
    Bullet.add_safelist type: :unused_eager_loading, class_name: 'ActiveStorage::Blob', association: :preview_image_attachment
    Bullet.add_safelist type: :unused_eager_loading, class_name: 'ActiveStorage::Blob', association: :variant_records
    Bullet.add_safelist type: :unused_eager_loading, class_name: 'ActiveStorage::VariantRecord', association: :image_attachment
  end
  config.action_controller.raise_on_missing_callback_actions = true
end
