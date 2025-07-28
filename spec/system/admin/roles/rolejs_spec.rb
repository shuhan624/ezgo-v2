require 'rails_helper'

RSpec.describe "角色權限連動", type: :system do
  before(:all) do
    @cw_admin = create(:cw_chief)
  end
  after(:all) do
    Admin.delete_all
  end

  let!(:role) { create(:role) }
  before { login_as(@cw_admin, scope: :admin) }

  exclude_models = %i(tag dashboard order contact setting dashboard)
  Role.default_permissions.except(*exclude_models).keys.each do |model_key|
    model = model_key.to_s

    context "當 model 為 #{model} 時" do
      it "勾選 show 時，自動勾選 index" do
        visit edit_admin_role_path(role)

        within(".role_permissions_#{model}_show") do
          check(I18n.t('permissions.show'), allow_label_click: true)
        end

        within(".role_permissions_#{model}_index") do
          checkbox = find("input#role_permissions_#{model}_index", visible: false)
          expect(checkbox).to be_checked
        end
      end

      %w(new create edit update destroy).each do |action|
        it "勾選 #{action} 時，自動勾選 index 與 show" do
          visit edit_admin_role_path(role)
          within(".role_permissions_#{model}_#{action}") do
            check(I18n.t("permissions.#{action}"), allow_label_click: true)
          end

          within(".role_permissions_#{model}_index") do
            checkbox = find("input#role_permissions_#{model}_index", visible: false)
            expect(checkbox).to be_checked
          end

          within(".role_permissions_#{model}_show") do
            checkbox = find("input#role_permissions_#{model}_show", visible: false)
            expect(checkbox).to be_checked
          end
        end
      end
    end
  end
end
