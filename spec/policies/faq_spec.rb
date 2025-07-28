require 'rails_helper'

RSpec.describe FaqPolicy, type: :policy do
  subject { described_class }

  let!(:faq) { create(:faq) }
  let!(:cw_admin) { create(:cw_chief) }
  let!(:no_permissions_admin) { create(:admin) }
  let!(:permit_role) { create(:role, permissions: {
                          faq: {
                            index: true,
                            show: true,
                            new: true,
                            create: true,
                            edit: true,
                            update: true,
                            destroy: true
                          }
                        })
                      }
  let!(:admin_has_permissions) { create(:admin, role: permit_role) }

  %i(index? show? new? create? edit? update? destroy?).each do |action|
    permissions action do
      it "CW Admin 有權限可以 #{action} on Faq" do
        expect(subject).to permit(cw_admin, faq)
      end

      it "沒有權限的 Admin 無法 #{action} Faq" do
        expect(subject).not_to permit(no_permissions_admin, faq)
      end

      it "有權限的 Admin 可以 #{action} on Faq" do
        expect(subject).to permit(admin_has_permissions, faq)
      end
    end
  end
end
