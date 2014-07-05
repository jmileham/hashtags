class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :content, index: true
      t.integer :votes

      t.timestamps
    end
  end
end
