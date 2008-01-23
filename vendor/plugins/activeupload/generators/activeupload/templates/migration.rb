class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments, :force => true do |t|
      t.column :filename,        :string
      t.column :size,            :integer
      t.column :attachable_id,   :integer
      t.column :attachable_type, :string
      t.column :created_at,      :datetime
    end
  end

  def self.down
    drop_table :attachments
  end
end

