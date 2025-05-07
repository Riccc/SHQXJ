namespace :import do
  desc "从Excel导入历史天气数据到weather_histories表"
  task weather_data_add: :environment do
    require "roo"

    # 设置文件路径
    file_path = Rails.root.join("db", "weather_data_add.xlsx").to_s

    # 验证文件存在性
    unless File.exist?(file_path)
      puts "❌ 错误：找不到Excel文件 #{file_path}"
      return
    end

    puts "⏳ 开始处理天气数据导入..."

    begin
      # 打开Excel文件
      xlsx = Roo::Spreadsheet.open(file_path)
      sheet = xlsx.sheet(0)  # 使用第一个工作表

      # 获取表头映射
      headers = {
        "日期" => :date,
        "平均气温(℃)" => :avg_temperature,
        "最高气温(℃)" => :max_temperature,
        "最低气温(℃)" => :min_temperature,
        "降水量(mm)" => :precipitation,
        "平均风速(m/s)" => :avg_wind_speed,
        "平均相对湿度(%)" => :avg_relative_humidity
      }

      ActiveRecord::Base.transaction do
        (2..sheet.last_row).each do |row_num|
          row_data = sheet.row(row_num)

          # 解析日期格式YYYYMMDD
          date_str = row_data[0].to_s
          year = date_str[0..3].to_i
          month = date_str[4..5].to_i
          day = date_str[6..7].to_i

          WeatherHistory.create!(
            year: year,
            month: month,
            day: day,
            avg_temperature: row_data[1],
            max_temperature: row_data[2],
            min_temperature: row_data[3],
            precipitation: row_data[4],
            avg_wind_speed: row_data[5],
            avg_relative_humidity: row_data[6]
          )

          # 每处理100条输出进度
          puts "已处理 #{row_num - 1} 条记录..." if (row_num - 1) % 100 == 0
        end
      end

      puts "✅ 天气数据导入成功！共导入 #{sheet.last_row - 1} 条记录"
    rescue ActiveRecord::RecordInvalid => e
      puts "❌ 数据验证失败：#{e.record.errors.full_messages.join(', ')}"
      raise ActiveRecord::Rollback
    rescue => e
      puts "❌ 发生错误：#{e.message}"
      puts e.backtrace.take(5).join("\n")
      raise ActiveRecord::Rollback
    end
  end
end