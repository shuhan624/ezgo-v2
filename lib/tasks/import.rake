# frozen_string_literal: true
require 'csv'

namespace :import do
  desc 'Import Products from CSV file'
  task products: :environment do

    # NOTICE! Becareful TRUNCATE TABLE !!!
    if true
      puts "Start Importing...TRUNCATE products..."
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE products RESTART IDENTITY CASCADE;')
    end

    CSV.foreach("#{Rails.root}/#{ARGV[1]}", encoding: 'UTF-8', headers: true, quote_char: '"') do |row|
      begin

        if row['成套'] == 'TRUE'
          category = Category.find_by(name: row['服飾系列'].strip)
          sport = Sport.find_by(name: row['運動類型'])
          slug = sport.slug + '-' + row['網址']
          fabric = Fabric.find_by(name: row['布料'])
          sizings = Sizing.where(name: %w(XS S M L XL 2XL 3XL 5XL))
          color = Color.find_or_create_by({ name: '黑', name_en: 'black', pure_color: PureColor.find_by(name_en: 'black')})

          # 新增成套商品的上衣
          top_product = Product.find_or_initialize_by(
                        name: row['商品名稱']&.strip + ' 上衣',
                        name_en: row['英文名稱']&.strip + ' Top',
                      )
          top_product.assign_attributes(
                      slug: slug + '-top',
                      sport: sport,
                      fabric: fabric,
                      status: 'hidden',
                      en_status: 'hidden',
                      is_bundle: 'false',
                      printing: row['製作方式'],
                      price: row['上衣售價'],
                      attr_tag_list: row['單雙面'],
                    )

          top_product.colors << color
          top_product.sizings << sizings
          top_product.categories << Category.find_by(name: '上衣')

          top_product.cover_image.attach(
            io: File.open('public/images/tmp/default-product.jpg'),
            filename: 'default-product.jpg'
          )

          top_product.save!

          puts "匯入「#{top_product.name}」成功！"

          # 新增成套商品的下著
          bottom_product = Product.find_or_initialize_by(
                      name: row['商品名稱']&.strip + ' 褲',
                      name_en: row['英文名稱']&.strip + ' Bottom',
                    )
          bottom_product.assign_attributes(
                      slug: slug + '-bottom',
                      sport: sport,
                      fabric: fabric,
                      status: 'hidden',
                      en_status: 'hidden',
                      is_bundle: 'false',
                      printing: row['製作方式'],
                      price: row['下著售價'],
                      attr_tag_list: row['單雙面'],
                    )

          bottom_product.colors << color
          bottom_product.sizings << sizings
          bottom_product.categories << Category.find_by(name: '下著')

          bottom_product.cover_image.attach(
            io: File.open('public/images/tmp/default-product.jpg'),
            filename: 'default-product.jpg'
          )

          bottom_product.save!
          puts "匯入「#{bottom_product.name}」成功！"

          # 新增成套商品
          bundle_product = Product.find_or_initialize_by(
                      name: row['商品名稱']&.strip + '（整套）',
                      name_en: row['英文名稱']&.strip,
                    )
          bundle_product.assign_attributes(
                      slug: slug,
                      category_ids: Category.where(name: %w[上衣 下著]).ids,
                      sport: sport,
                      fabric: fabric,
                      status: 'hidden',
                      en_status: 'hidden',
                      is_bundle: 'true',
                      printing: row['製作方式'],
                      price: row['售價'],
                      attr_tag_list: row['單雙面'],
                    )
          bundle_product.colors << color
          bundle_product.sizings << sizings
          bundle_product.products << top_product
          bundle_product.products << bottom_product

          bundle_product.cover_image.attach(
            io: File.open('public/images/tmp/default-product.jpg'),
            filename: 'default-product.jpg'
          )

          bundle_product.save!

          puts "匯入「#{bundle_product.name}」成功！"
        else
          category = Category.find_or_create_by(name: row['服飾系列'].strip)
          sport = Sport.find_by(name: row['運動類型']&.strip)
          slug = sport.slug + '-' + row['網址']&.strip
          fabric = Fabric.find_by(name: row['布料']&.strip)
          color = Color.find_or_initialize_by({ name: '黑', name_en: 'black', pure_color: PureColor.find_by(name_en: 'black')})
          product = Product.find_or_initialize_by(
                      name: row['商品名稱']&.strip,
                      name_en: row['英文名稱']&.strip,
                    )
          product.assign_attributes(
                      slug: slug,
                      sport: sport,
                      fabric: fabric,
                      status: 'hidden',
                      en_status: 'hidden',
                      is_bundle: 'false',
                      printing: row['製作方式']&.strip,
                      price: row['售價'],
                      attr_tag_list: row['單雙面']&.strip,
                    )

          if product.categories.present?
            product.categories = []
            product.categories.map do |cate_attrs|
              category = Category.find_by(name: cate_attrs[:name])
              if category.present?
                product.categories << category
              else
                product.categories << Category.create(cate_attrs)
              end
            end
          end

          product.categories << category
          product.colors << color

          product.cover_image.attach(
            io: File.open('public/images/tmp/default-product.jpg'),
            filename: 'default-product.jpg'
          )

          product.save!

          puts "匯入「#{product.name}」成功！"
        end

      rescue ActiveRecord::RecordInvalid, ArgumentError => e
        puts "============== ERROR 匯入出現問題！ ===================="
        puts e.message
      end
    end
  end
end
