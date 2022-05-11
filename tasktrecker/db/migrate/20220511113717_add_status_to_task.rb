class AddStatusToTask < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE task_statuses AS ENUM ('opened', 'closed');
    SQL
    add_column :tasks, :status, :task_statuses, null: false, default: 'opened'
  end

  def down
    remove_column :tasks, :status
    execute <<-SQL
      DROP TYPE task_statuses;
    SQL
  end
end
