require 'rails_helper'

RSpec.describe RedirectRulePolicy, type: :policy do
  subject { described_class }

  let!(:redirect_rule) { create(:redirect_rule) }
  let!(:cw_admin) { create(:cw_chief) }
  let!(:no_permissions_admin) { create(:admin) }
  let!(:permit_role) { create(:role, permissions: {
                        redirect_rule: {
                          index: true,
                          show: true,
                          new: true,
                          create: true,
                          edit: true,
                          update: true,
                          destroy: true,
                          sort: true
                        }
                      })
                    }
  let!(:admin_has_permissions) { create(:admin, role: permit_role) }

  %i(index? show? new? create? edit? update? destroy? sort?).each do |action|
    permissions action do
      it "CW Admin 有權限可以 #{action} on RedirectRule" do
        expect(subject).to permit(cw_admin, redirect_rule)
      end

      it "沒有權限的 Admin 無法 #{action} RedirectRule" do
        expect(subject).not_to permit(no_permissions_admin, redirect_rule)
      end

      it "有權限的 Admin 可以 #{action} on RedirectRule" do
        expect(subject).to permit(admin_has_permissions, redirect_rule)
      end
    end
  end
end
