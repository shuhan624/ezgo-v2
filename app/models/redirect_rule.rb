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
class RedirectRule < ApplicationRecord
  # == Constants ============================================================

  # == Extensions ===========================================================
  audited
  acts_as_list
  # == Attributes ===========================================================

  # == Relationships ========================================================

  # == Validations ==========================================================
  validates :source_path, presence: true, uniqueness: true
  validates :target_path, presence: true
  validate :start_with_slash
  validate :no_circular_redirects
  validate :no_inverse_redirect
  validate :no_conflict_source_path

  def start_with_slash
    errors.add(:source_path, '必須以 "/" 開頭') if source_path.present? && !source_path.starts_with?('/')
    errors.add(:target_path, '必須以 "/" 開頭') if target_path.present? && !target_path.starts_with?('/')
  end

  def no_circular_redirects
    errors.add(:target_path, '目標路徑不能與來源路徑相同') if source_path == target_path
  end

  def no_inverse_redirect
    errors.add(:base, '已存在一條完全相反的轉址規則') if RedirectRule.exists?(source_path: target_path, target_path: source_path)
  end

  def no_conflict_source_path
    return if source_path.nil?
    errors.add(:source_path, '不能是 /en') if source_path == '/en'
    errors.add(:source_path, '不能是 /en/') if source_path == '/en/'
    errors.add(:source_path, '不能是 /') if source_path == '/'

    # 目前網站已存在的路徑
    forbidden_segments = %w(products news preview faqs contact about team background milestones our-awards future-vision downloads privacy terms thanks user)

    # 用'/'分割路徑並去除空字串
    segments = source_path.split('/').reject(&:empty?)

    # 取'/'後的第一段網址，如果'/en'開頭，則取第二個部分
    segment_to_check = (segments.first == 'en')? segments.second : segments.first

    # 如果取得的網址字段已存在於網站中，或已有類似路徑，則回報錯誤，例如: /news, /faqs
    if forbidden_segments.include?(segment_to_check)
      errors.add(:source_path, '路徑已存在於網站中，或已有類似路徑')
    end
  end

  # == Scopes ===============================================================

  # == Callbacks ============================================================
  after_commit :reload_routes
  before_validation :normalize_redirect_paths

  def reload_routes
    Rails.application.reload_routes!
  end

  def normalize_redirect_paths
    self.source_path = normalize_path(source_path)
    self.target_path = normalize_path(target_path)
  end

  def normalize_path(path)
    return path if path.nil?
    # 刪除最前端和尾端的空格
    path = path.strip
  end

  # == Class Methods ========================================================
  def self.import(file)
    # 驗證檔案格式，如果是xlsx以外的就回傳false
    return false if File.extname(file.original_filename) != '.xlsx'

    excel = Creek::Book.new(file.path, with_headers: true)
    sheet = excel.sheets[0]

    sheet.simple_rows.drop(1).each do |row|
      begin
        redirect_rule = RedirectRule.find_or_initialize_by(source_path: row['舊網站路徑']&.strip)
        redirect_rule.source_path = row['舊網站路徑'].to_s
        redirect_rule.target_path = row['新網站路徑'].to_s
        redirect_rule.save!
      rescue ActiveRecord::RecordInvalid, ArgumentError => e
        puts "============== ERROR 匯入出現問題！ ===================="
        puts row.inspect
        puts e.message
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w(source_path target_path position updated_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(audits)
  end

  # == Instance Methods =====================================================
end
