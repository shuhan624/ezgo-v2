class RolePolicy < ApplicationPolicy
  # 因為沒有要出現 Role 的權限設定給管理員，所以這邊直接繼承 ApplicationPolicy 就好
end
