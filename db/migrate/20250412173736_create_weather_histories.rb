class CreateWeatherHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :weather_histories do |t|
      t.integer :year
      t.integer :month
      t.integer :day
      t.float :avg_temperature
      t.float :max_temperature
      t.float :min_temperature
      t.float :precipitation
      t.float :avg_wind_speed
      t.integer :avg_relative_humidity
      t.string :weather_summary
      t.string :rain_volume

      t.timestamps
    end
  end
end
