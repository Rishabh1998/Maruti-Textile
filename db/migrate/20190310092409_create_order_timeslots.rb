class CreateOrderTimeslots < ActiveRecord::Migration[5.2]
  def change
    create_table :order_timeslots do |t|
      t.integer :order_id
      t.string :date
      t.string :timeslot

      t.timestamps
    end
  end
end
