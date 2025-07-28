# == Schema Information
#
# Table name: redirect_rules
#
#  id                    :bigint           not null, primary key
#  source_path(來源路徑) :string
#  target_path(目標路徑) :string
#  position(排序)        :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require 'rails_helper'

RSpec.describe RedirectRule, type: :model do
  subject(:redirect_rule) { build(:redirect_rule) }
  let(:redirect_rule) { create(:redirect_rule) }

  context '格式驗證' do
    it 'is valid with valid attributes' do
      expect(redirect_rule).to be_valid
    end

    it '「來源網址」為必填欄位' do
      redirect_rule = build(:redirect_rule, source_path: nil)
      expect(redirect_rule).not_to be_valid

      redirect_rule = build(:redirect_rule, source_path: '')
      expect(redirect_rule).not_to be_valid
    end

    it '「來源網址」不可以重複' do
      redirect_rule = create(:redirect_rule)
      redirect_rule2 = build(:redirect_rule, source_path: redirect_rule.source_path)

      expect(redirect_rule2).not_to be_valid
    end

    it '「來源網址」不可以與「目標網址」相同' do
      redirect_rule = build(:redirect_rule, source_path: '/test-path', target_path: '/test-path')
      expect(redirect_rule).not_to be_valid
    end

    it '不可以有兩條完全相反的轉址規則' do
      redirect_rule = create(:redirect_rule, source_path: '/test-sourthpath', target_path: '/test-targetpath')
      redirect_rule2 = build(:redirect_rule, source_path: '/test-targetpath', target_path: '/test-sourthpath')
      expect(redirect_rule2).not_to be_valid
    end

    it '「目標網址」為必填欄位' do
      redirect_rule = build(:redirect_rule, target_path: nil)
      expect(redirect_rule).not_to be_valid

      redirect_rule = build(:redirect_rule, target_path: '')
      expect(redirect_rule).not_to be_valid
    end

    it '「來源網址」必須以 "/" 開頭' do
      redirect_rule = build(:redirect_rule, source_path: 'company-profile')
      expect(redirect_rule).not_to be_valid
    end

    it '「目標網址」必須以 "/" 開頭' do
      redirect_rule = build(:redirect_rule, target_path: 'company-profile')
      expect(redirect_rule).not_to be_valid
    end
  end

  context 'normalize 驗證' do
    context 'source_path' do
      it '前面有空格會被去除' do
        redirect_rule = create(:redirect_rule, source_path: ' /test-path')
        expect(redirect_rule.source_path).to eq('/test-path')
      end

      it '後面有空格會被去除' do
        redirect_rule = create(:redirect_rule, source_path: '/test-path ')
        expect(redirect_rule.source_path).to eq('/test-path')
      end

      it '中間有空格不會被去除' do
        redirect_rule = create(:redirect_rule, source_path: '/test path')
        expect(redirect_rule.source_path).to eq('/test path')
      end
    end

    context 'target_path' do
      it '前面有空格會被去除' do
        redirect_rule = create(:redirect_rule, target_path: ' /test-path')
        expect(redirect_rule.target_path).to eq('/test-path')
      end

      it '後面有空格會被去除' do
        redirect_rule = create(:redirect_rule, target_path: '/test-path ')
        expect(redirect_rule.target_path).to eq('/test-path')
      end

      it '中間有空格不會被去除' do
        redirect_rule = create(:redirect_rule, target_path: '/test path')
        expect(redirect_rule.target_path).to eq('/test path')
      end
    end
  end

  context 'no_conflick_source path 驗證' do
    it '「來源網址」不能是 /en' do
      redirect_rule = build(:redirect_rule, source_path: '/en')
      expect(redirect_rule).not_to be_valid
    end

    %w(products news preview faqs contact about team background milestones our-awards future-vision downloads privacy terms thanks user).each do |segment|
      it "「來源網址」不能是 /#{segment}" do
        redirect_rule = build(:redirect_rule, source_path: "/#{segment}")
        expect(redirect_rule).not_to be_valid
      end

      it "「來源網址」不能是 /en/#{segment}" do
        redirect_rule = build(:redirect_rule, source_path: "/en/#{segment}")
        expect(redirect_rule).not_to be_valid
      end

      # 先不讓輸入者輸入會混淆的路徑，未來如有需要可再更改model_validation
      it "「來源網址」不能是 /#{segment} 開頭" do
        redirect_rule = build(:redirect_rule, source_path: "/#{segment}/#{FFaker::Lorem.characters.first(10)}")
        expect(redirect_rule).not_to be_valid
      end

      it "「來源網址」不能是 /en/#{segment} 開頭" do
        redirect_rule = build(:redirect_rule, source_path: "/en/#{segment}/#{FFaker::Lorem.characters.first(10)}")
        expect(redirect_rule).not_to be_valid
      end
    end
  end

  context '資料匯入 驗證' do
    it '只可為 xlsx 檔案' do
      file = fixture_file_upload('spec/fixtures/test.xlsx')
      expect(RedirectRule.import(file)).to be_truthy
    end

    it '不可為 xls 檔案' do
      file = fixture_file_upload('spec/fixtures/test.xls')
      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可為 pdf 檔案' do
      file = fixture_file_upload('spec/fixtures/test.pdf')
      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可為 jpg 檔案' do
      file = fixture_file_upload('spec/fixtures/image.jpg')
      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可為 gif 檔案' do
      file = fixture_file_upload('spec/fixtures/test.gif')
      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可為 csv 檔案' do
      file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Tempfile.new,
        filename: 'test.csv',
        type: 'text/csv'
      )

      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可為 numbers 檔案' do
      file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Tempfile.new,
        filename: 'test.numbers',
        type: 'application/vnd.apple.numbers'
      )

      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可以是 docx 檔案' do
      file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Tempfile.new,
        filename: 'test.docx',
        type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      )

      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可以是 doc 檔案' do
      file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Tempfile.new,
        filename: 'test.doc',
        type: 'application/msword'
      )

      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可以是 txt 檔案' do
      file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Tempfile.new,
        filename: 'test.txt',
        type: 'text/plain'
      )

      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可以是 pptx 檔案' do
      file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Tempfile.new,
        filename: 'test.pptx',
        type: 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
      )

      expect(RedirectRule.import(file)).to be_falsey
    end

    it '不可以是 ppt 檔案' do
      file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Tempfile.new,
        filename: 'test.ppt',
        type: 'application/vnd.ms-powerpoint'
      )

      expect(RedirectRule.import(file)).to be_falsey
    end
  end
end
