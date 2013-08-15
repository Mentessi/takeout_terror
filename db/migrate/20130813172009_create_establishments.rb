class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      
      t.integer :fhrsid 
      t.string :local_authority_business_id
      t.string :business_name
      t.string :business_type
      t.string :business_type_id
      t.string :address_line_1
      t.string :address_line_2
      t.string :address_line_3
      t.string :address_line_4
      t.string :postcode
      t.integer :rating_value
      t.string :rating_key
      t.datetime :rating_date
      t.string :local_authority_code
      t.string :local_authority_name
      t.string :local_authority_website
      t.string :local_authority_email_address
      t.integer :scores_hygiene
      t.integer :scores_structual
      t.integer :scores_confidence_in_management
      t.string :scheme_type
      t.decimal :Geocode_Longitude, :precision => 16, :scale => 14
      t.decimal :Geocode_Latitude, :precision => 16, :scale => 14
      
      t.timestamps
    end
  end
end
