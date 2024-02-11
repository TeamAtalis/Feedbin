class ChangePlanIdTypeToString < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :new_plan_id, :string
    User.find_each do |user|
      user.update(new_plan_id: user.plan_id)
    end
    safety_assured { remove_column :users, :plan_id }
    safety_assured { rename_column :users, :new_plan_id, :plan_id }
  end
end
