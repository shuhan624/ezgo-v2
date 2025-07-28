require 'rails_helper'

RSpec.describe ArticleCategoryPolicy, type: :policy do
  subject { described_class }

  let!(:article_category) { create(:article_category) }
  let!(:cw_admin) { create(:cw_chief) }
  let!(:no_permissions_admin) { create(:admin) }
  let!(:permit_role) { create(:role, permissions: {
                          article_category: {
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
      it "CW Admin 有權限可以 #{action} on ArticleCategory" do
        expect(subject).to permit(cw_admin, article_category)
      end

      it "沒有權限的 Admin 無法 #{action} ArticleCategory" do
        expect(subject).not_to permit(no_permissions_admin, article_category)
      end

      it "有權限的 Admin 可以 #{action} on ArticleCategory" do
        expect(subject).to permit(admin_has_permissions, article_category)
      end
    end
  end
end
