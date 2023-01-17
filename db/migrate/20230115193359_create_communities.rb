class CreateCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :communities do |t|
      t.string :sub_dir, index: { unique: true }
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
