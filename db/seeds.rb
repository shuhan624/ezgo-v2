puts 'Start Seeding...'

seeds = case Rails.env
        when 'development'
          %i(settings admins custom_pages homeslides articles redirect_rules menus)
        when 'test'
          %i(settings redirect_rules menus)
        else # 'production', 'staging'
          %i(settings admins custom_pages homeslides articles menus)
        end

seeds.each do |table|
  load "db/seeds/#{table}.rb"
  puts "#{table} seed done."
end

puts '٩(๑❛ᴗ❛๑)۶ ~ All Seeds Done.'
