# frozen_string_literal: true

namespace :shipment do
  namespace :hct do
    # Usage:
    #
    # $ rake shipment:hct:query_packages ids="3373023710 3373023721"
    #
    desc 'Query HCT package status (STDOUT)'
    task query_packages: :environment do
      ids = ENV['ids']&.split(' ')
      
      service = ::ShipmentService::Hct::QueryPackages.new(package_ids: ids)
      result = service.call
      
      puts "********************************************"
      puts "Query HCT packages status at #{DateTime.now}"
      puts "#{result.success? ? 'Success!' : result.error }"
      puts result.payload.to_s
      puts "Arrived Packages: #{result.arriveds.join(', ')} "
      puts "Delivering Packages: #{result.deliverings.join(', ')}"
    end
    
    desc 'Update HCT pacakges status ("log/shipment.log")'
    task update_packages: :environment do
      
      logger = Logger.new("#{Rails.root}/log/shipment.log")
      
      Order.dispatching.find_in_batches(batch_size: 100) do |orders|
        ids = orders.map(&:tracking_number)
        service = ::ShipmentService::Hct::QueryPackages.new(package_ids: ids)
        result = service.call
        
        if result.success?
          # change status to be delivering
          Order.shipped.where(tracking_number: result.deliverings).each(&:dispatch!)
          
          # change status to be arrived
          Order.dispatching
               .where(tracking_number: result.arriveds)
               .each(&:arrive!)
        end
        
        logger.info "********************************************"
        logger.info "Query HCT packages status at #{DateTime.now}"
        logger.info "#{result.success? ? 'Success!' : result.error }"
        logger.info result.payload.to_s
        logger.info "Arrived Packages: #{result.arriveds.join(', ')} "
        logger.info "Delivering Packages: #{result.deliverings.join(', ')}"
      end
    end
  end
end
