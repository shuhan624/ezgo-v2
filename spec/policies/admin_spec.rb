require 'rails_helper'

RSpec.describe AdminPolicy, type: :policy do
  subject { described_class }

  let!(:admin_resource) { create(:admin) }
  let!(:cw_admin) { create(:cw_chief) }
  let!(:no_permissions_admin) { create(:admin) }
  let!(:permit_role) { create(:role, permissions: {
                        admin: {
                          index: true,
                          show: true,
                          new: true,
                          create: true,
                          edit: true,
                          update: true,
                          destroy: true,
                        }
                      })
                    }
  let!(:admin_has_permissions) { create(:admin, role: permit_role) }

  %i(index? show? new? create? edit? update? destroy?).each do |action|
    permissions action do
      it "CW Admin 有權限可以 #{action} on Admin" do
        expect(subject).to permit(cw_admin, admin_resource)
      end

      it "沒有權限的 Admin 無法 #{action} Admin" do
        expect(subject).not_to permit(no_permissions_admin, admin_resource)
      end

      it "有權限的 Admin 可以 #{action} on Admin" do
        expect(subject).to permit(admin_has_permissions, admin_resource)
      end
    end
  end
end
