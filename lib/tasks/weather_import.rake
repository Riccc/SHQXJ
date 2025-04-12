namespace :import do
  desc "Import weather data from Excel to weather_histories table"
  task weather_data: :environment do
    require "roo"

    # 构建文件路径并转换为字符串
    file_path = Rails.root.join("db", "weather_data.xlsx").to_s

    # 检查文件路径是否存在
    unless File.exist?(file_path)
      puts "❌ 文件不存在：#{file_path}"
      return
    end

    # 使用 Roo 读取 Excel 文件
    xlsx = Roo::Spreadsheet.open(file_path)

    # 获取表头
    header = xlsx.row(1)

    puts "开始导入天气数据..."

    # 使用事务确保数据导入的原子性
    ActiveRecord::Base.transaction do
      (2..xlsx.last_row).each do |i|
        row = Hash[[header, xlsx.row(i)].transpose]

        # 创建记录
        WeatherHistory.create!(
          year: row["年份"],
          month: row["月份"],
          day: row["日期"],
          avg_temperature: row["平均气温"],
          max_temperature: row["最高气温"],
          min_temperature: row["最低气温"],
          precipitation: row["降水量"],
          avg_wind_speed: row["平均风速"],
          avg_relative_humidity: row["平均相对湿度"],
          weather_summary: row["天气现象摘要"],
          rain_volume: row["雨量"]
        )
      end
    end

    puts "✅ 所有数据导入成功！"
  rescue => e
    puts "❌ 数据导入失败，事务已回滚！"
    puts "错误信息：#{e.message}"
  end
end
