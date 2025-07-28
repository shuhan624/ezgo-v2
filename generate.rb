# frozen_string_literal: true

require 'colorize'

[
  ['user', 'account:string name:string'],
  # ['user', 'email:string address:string admin:boolean birthday:date city:string dist:string gender:boolean nickname:string phone:string realname:string zip_code:string'],
  # ['channel', 'title_en:string title:string parent_id:integer']
  # ['wallet', 'user:references balance:decimal'],
].each do |model_name, columns|
  puts <<~TEXT
    #{model_name.blue} | #{columns.red}
  TEXT
  # `bin/rails g model #{model_name} #{columns}`
  # `bin/rails generate factory_bot:model #{model_name}`
  # `bin/rails g scaffold_controller admin/#{model_name} #{columns} --model-name=#{model_name} --force`
  `bin/rails g scaffold_controller admin/#{model_name} #{columns} --model-name=#{model_name}`
  `bin/rails g rspec:model #{model_name}`
  `bin/rails g pundit:policy #{model_name}`
  `bin/rails g decorator #{model_name}`
end
