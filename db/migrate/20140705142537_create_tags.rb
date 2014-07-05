class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :content
      t.number :votes

      t.timestamps
    end
  end
end
