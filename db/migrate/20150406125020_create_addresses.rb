class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string  :full_name
      t.text    :full_address
      t.string  :phone_number

      t.timestamps
    end
  end
end
