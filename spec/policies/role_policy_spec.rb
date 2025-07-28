require 'rails_helper'

RSpec.describe RolePolicy, type: :policy do
  subject { described_class }

  let!(:role) { build(:role) }
  let!(:cw_admin) { create(:cw_chief) }
  let!(:no_permissions_admin) { create(:admin) }

  %i(index? show? new? create? edit? update? destroy?).each do |action|
    permissions action do
      it "CW Admin 有權限可以 #{action} on Role" do
        expect(subject).to permit(cw_admin, role)
      end

      it '一般的 Admin 無法存取 Role' do
        expect(subject).not_to permit(no_permissions_admin, role)
      end

      # 因為 Role 不會出現在權限設定的畫面上，所以不需要這個測試
      # it "有權限的 Admin 可以 #{action} on Role" do
      #   expect(subject).to permit(admin_has_permission, role)
      # end
    end
  end
end
