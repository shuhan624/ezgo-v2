require 'rails_helper'

RSpec.describe "刪除單一里程碑", type: :system do
  let(:milestone) { create(:milestone) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      milestone: {
        index: true,
        show: true,
        edit: true,
        destroy: true,
      }
    })

    @no_permit_role = create(:role, permissions: {
      milestone: {
        index: true,
        show: true,
        edit: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, role: @no_permit_role)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀       ▀
#

  context "在單一里程碑編輯頁" do
    it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
      login_as(@no_permissions_admin, scope: :admin)
      visit edit_admin_milestone_path(milestone)
      expect(page).not_to have_css('.float-btns .btn-danger-light')
    end

    it "有 destroy 權限者，可以看到「刪除」按鈕" do
      login_as(@admin_has_permissions, scope: :admin)
      visit edit_admin_milestone_path(milestone)
      expect(page).to have_css('.float-btns .btn-danger-light')
    end

    it "有 destroy 權限者，可以「刪除」里程碑" do
      login_as(@admin_has_permissions, scope: :admin)
      destroy_milestone_on_edit_page
      notice = find('.bootstrap-notify-container')
      expect(notice).to have_content('成功删除 里程碑')
      count = Milestone.count
      expect(count).to eq(4)
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌   ▄   ▐░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌
#   ▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌ ▐░▌░▌ ▐░▌
#            ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌
#   ▄▄▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌░▌   ▐░▐░▌
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀       ▀▀
#

  context "在單一里程碑檢視頁" do
    it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_milestone_path(milestone)
      expect(page).not_to have_css('.float-btns .btn-danger-light')
    end

    it "有 destroy 權限者，可以看到「刪除」按鈕" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_milestone_path(milestone)
      expect(page).to have_css('.float-btns .btn-danger-light')
    end

    it "有 destroy 權限者，可以「刪除」里程碑" do
      login_as(@admin_has_permissions, scope: :admin)
      destroy_milestone_on_show_page
      notice = find('.bootstrap-notify-container')
      expect(notice).to have_content('成功删除 里程碑')
      count = Milestone.count
      expect(count).to eq(4)
    end
  end

#   ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄
#  ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#  ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
#  ▐░▌▐░▌ ▐░▌▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀
#

  def destroy_milestone_on_edit_page
    milestones = create_list(:milestone, 5)
    target_milestone = milestones.first
    visit edit_admin_milestone_path(target_milestone)
    find('.float-btns .btn-danger-light', match: :first).click
    page.driver.browser.switch_to.alert.accept
  end

  def destroy_milestone_on_show_page
    milestones = create_list(:milestone, 5)
    target_milestone = milestones.first
    visit admin_milestone_path(target_milestone)
    find('.float-btns .btn-danger-light', match: :first).click
    page.driver.browser.switch_to.alert.accept
  end
end
