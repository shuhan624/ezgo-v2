require 'rails_helper'

RSpec.describe ArticlePolicy, type: :policy do
  subject { described_class }

  let!(:article) { create(:article) }
  let!(:cw_admin) { create(:cw_chief) }
  let!(:no_permissions_admin) { create(:admin) }
  let!(:permit_role) { create(:role, permissions: {
                          article: {
                            index: true,
                            show: true,
                            new: true,
                            create: true,
                            edit: true,
                            update: true,
                            destroy: true,
                            preview: true,
                            copy: true,
                            show_tags: true
                          }
                        })
                      }
  let!(:admin_has_permissions) { create(:admin, role: permit_role) }

  %i(index? show? preview? new? create? edit? update? destroy? copy? show_tags?).each do |action|
    permissions action do
      it "CW Admin 有權限可以 #{action} on Article" do
        expect(subject).to permit(cw_admin, article)
      end

      it "沒有權限的 Admin 無法 #{action} Article" do
        expect(subject).not_to permit(no_permissions_admin, article)
      end

      it "有權限的 Admin 可以 #{action} on Article" do
        expect(subject).to permit(admin_has_permissions, article)
      end
    end
  end
end
