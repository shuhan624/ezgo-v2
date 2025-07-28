# == Schema Information
#
# Table name: documents
#
#  id                  :bigint           not null, primary key
#  attachable_type     :string
#  attachable_id       :bigint
#  title(標題)         :string
#  slug(slug)          :string
#  file_type(檔案類型) :string           default("file")
#  language(檔案語系)  :string
#  link(連結)          :string
#  spec(其他)          :jsonb
#  position(排列順序)  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_documents_on_attachable  (attachable_type,attachable_id)
#  index_documents_on_slug        (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Document, type: :model do
  let(:document) { create(:document) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(document).to be_valid
    end

    it '「標題」為必填欄位' do
      document = build(:document, title: nil)
      expect(document).not_to be_valid

      document = build(:document, title: '')
      expect(document).not_to be_valid
    end

    it '「標題」可以重複' do
      document2 = build(:document, title: document.title)
      expect(document2).to be_valid
    end

    it '當「檔案類型」為「file」時，「檔案」為必填欄位' do
      document = build(:document, file_type: 'file')
      expect(document).not_to be_valid
    end

    it '當「檔案類型為「file」時，「slug」為必填欄位' do
      document = build(:document,
                        file_type: 'file',
                        slug: nil)
      expect(document).not_to be_valid

      document = build(:document,
                        file_type: 'file',
                        slug: '')
      expect(document).not_to be_valid
    end

    it '當「檔案類型」為「link」時，「連結」為必填欄位' do
      document = build(:document,
                        file_type: 'link',
                        link: nil)
      expect(document).not_to be_valid

      document = build(:document,
                        file_type: 'link',
                        link: '')
      expect(document).not_to be_valid
    end

    context "檔案格式 驗證" do
      let(:document) { build(:document, file_type: 'file') }
      it '可以是「pdf」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.pdf', content_type: 'application/pdf')
        expect(document).to be_valid
      end

      it '不可以是「txt」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.txt', content_type: 'text/plain')
        expect(document).not_to be_valid
      end

      it '不可以是「doc」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.doc', content_type: 'application/msword')
        expect(document).not_to be_valid
      end

      it '不可以是「docx」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.doc', content_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        expect(document).not_to be_valid
      end

      it '不可以是「xls」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.xls', content_type: 'application/vnd.ms-excel')
        expect(document).not_to be_valid
      end

      it '不可以是「xlsx」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.xlsx', content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        expect(document).not_to be_valid
      end

      it '不可以是「csv」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.csv', content_type: 'text/csv')
        expect(document).not_to be_valid
      end

      it '不可以是「ppt」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.ppt', content_type: 'application/vnd.ms-powerpoint')
        expect(document).not_to be_valid
      end

      it '不可以是「pptx」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.pptx', content_type: 'application/vnd.openxmlformats-officedocument.presentationml.presentation')
        expect(document).not_to be_valid
      end

      it '不可以是「jpg」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.jpg', content_type: 'image/jpeg')
        expect(document).not_to be_valid
      end

      it '不可以是「png」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.png', content_type: 'image/png')
        expect(document).not_to be_valid
      end

      it '不可以是「gif」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.gif', content_type: 'image/gif')
        expect(document).not_to be_valid
      end

      it '不可以是「zip」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.zip', content_type: 'application/zip')
        expect(document).not_to be_valid
        document.file.attach(io: file, filename: 'test.zip', content_type: 'application/x-zip-compressed')
        expect(document).not_to be_valid
      end

      it '不可以是「rar」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.rar', content_type: 'application/vnd.rar')
        expect(document).not_to be_valid
      end
    end

    context "檔案大小 驗證" do
      it '不可以超過「15MB」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 16.megabytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.pdf', content_type: 'application/pdf')
        expect(document).not_to be_valid
      end

      it '可以是「15MB」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 15.megabytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.pdf', content_type: 'application/pdf')
        expect(document).to be_valid
      end

      it '不可以小於「1KB」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 500.bytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.pdf', content_type: 'application/pdf')
        expect(document).not_to be_valid
      end

      it '不可以為「0 KB」' do
        file = StringIO.new(FFaker::Lorem.paragraph)
        file.write('a' * 0.kilobytes)
        file.rewind

        document.file.attach(io: file, filename: 'test.pdf', content_type: 'application/pdf')
        expect(document).not_to be_valid
      end
    end
  end
end
