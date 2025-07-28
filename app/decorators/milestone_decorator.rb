class MilestoneDecorator < ApplicationDecorator
  delegate_all

  def date
    object.date.strftime("%Y.%m")
  end

  ############################## 後台 Admin ##############################
  def short_content
    object.content.first(16).strip if object.content.present?
  end
end
