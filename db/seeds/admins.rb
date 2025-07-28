[
  { name: '總管理員' },
  { name: '編輯' },
  { name: '客服' }
].each do |role|
  Role.find_or_create_by(name: role[:name])
end

master_role = Role.find_by(name: '總管理員')
dummy_admin = Admin.new
permissions = {}
Role.default_permissions.each do |target, model|
  next if target == :dashboard
  policies = Pundit.policy(dummy_admin, model.constantize)
  actions = policies.public_methods(false).map { |method| [method.to_s.delete_suffix('?'), true] }.to_h
  permissions[target] = actions.except('permitted_attributes')
end

master_role.permissions = permissions
master_role.save

[
  {
    email: 'cwadmin@example.com',
    name: '前網管理員1號',
    cw_chief: true,
    password: 'admin$ezimmi',
    password_confirmation: 'admin$ezimmi',
    language: {
      tw: true,
      en: true,
    },
  },
  {
    email: 'admin@example.com',
    name: '總管理員',
    role: master_role,
    password: 'admin@tw#EM',
    password_confirmation: 'admin@tw#EM',
    language: {
      tw: true,
      en: false,
    },
  }
].each do |admin|
  Admin.create(admin)
end
