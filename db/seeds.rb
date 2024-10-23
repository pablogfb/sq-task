require 'csv'

# Import merchants
merchants = 0
csv_content = File.read(Rails.root.join('db', 'merchants.csv'))

CSV.parse(csv_content, headers: true, col_sep: ';').each do |row|
  merchant = Merchant.new
  merchant.reference = row['reference']
  merchant.email = row['email']
  merchant.live_on = Date.parse(row['live_on'])
  merchant.disbursement_frequency = row['disbursement_frequency'] == 'WEEKLY' ? :weekly : :daily
  merchant.minimum_monthly_fee = row['minimum_monthly_fee'].to_f * 100
  merchant.save
  merchants += 1
end
puts "Created #{merchants} merchants"

puts "Importing orders..."
# Import orders. 
# We need a different approach because the data size.
# We need to import it directly on the database. As a result, we need
# to create a temporary table and then insert the data into it. Then
# we match the merchant_id with the correct reference and insert the
# data in the orders table. Finaly we drop the temporary table.

def import_csv(file_path)
  # Create a temporary table to import the data
  temp_table_sql = "CREATE TEMPORARY TABLE temp_table (
    id VARCHAR PRIMARY KEY,
    merchant_reference VARCHAR,
    amount FLOAT,
    created_at TIMESTAMP
  );"
  ActiveRecord::Base.connection.execute(temp_table_sql)

  # Import the data into the temporary table
  copy_sql = "COPY temp_table (id,merchant_reference, amount, created_at)
    FROM '#{file_path}'
    DELIMITER ';'
    CSV HEADER;"
  ActiveRecord::Base.connection.execute(copy_sql)

  # Insert the data into the final table with the correct merchant_id
  insert_sql = "INSERT INTO orders (merchant_id, amount, created_at, updated_at)
    SELECT m.id, t.amount * 100, t.created_at, t.created_at
    FROM temp_table t
    JOIN merchants m ON t.merchant_reference = m.reference;"
  ActiveRecord::Base.connection.execute(insert_sql)

  # Drop the temporary table
  drop_sql = "DROP TABLE temp_table;"
  ActiveRecord::Base.connection.execute(drop_sql)
end

# The orders data is in a CSV file loaded from the db/orders.csv and imported
# to pg docker container as a volume (see docker-compose.yml) so pg can read it.
import_csv('/db/orders.csv')
puts "Orders imported"
