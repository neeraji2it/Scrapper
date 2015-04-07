class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text  :full_name
      t.text  :full_address
      t.text  :phone_number

      t.timestamps
    end
  end
end
