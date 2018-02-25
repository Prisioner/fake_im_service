class CreateMessageStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :message_statuses do |t|
      t.references :message, index: true, foreign_key: true
      t.references :recipient, index: true, foreign_key: true
      t.string :status
      t.string :details

      t.timestamps
    end
  end
end
