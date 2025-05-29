class ShareController < ApplicationController
  # 禁用CSRF验证
  protect_from_forgery with: :null_session
  def show
    @name = params[:name]
    @birthday = params[:birthday]
    @chosen_date = params[:chosen_date]
    @low_temp = params[:low_temp]
    @high_temp = params[:high_temp]
    @selected_text_content = params[:selected_text_content]
    @chosen_img = params[:chosen_img]
    @chosen_text = params[:chosen_text]

    # 解析生日，假设生日格式为 yyyy-mm-dd
    birthday_parts = @birthday.split('-')
    year = birthday_parts[0].to_i
    month = birthday_parts[1].to_i
    day = birthday_parts[2].to_i

    # 查询数据库中对应日期的天气数据
    @birthday_weather = WeatherHistory.find_by(year: year, month: month, day: day)

    # 将生日当天的天气数据保存在一个可用的变量中
    if @birthday_weather
      @birthday_weather_data = {
        avg_temp: @birthday_weather.avg_temperature,
        max_temp: @birthday_weather.max_temperature,
        min_temp: @birthday_weather.min_temperature,
        precipitation: @birthday_weather.precipitation,
        wind_speed: @birthday_weather.avg_wind_speed,
        humidity: @birthday_weather.avg_relative_humidity,
        weather_summary: @birthday_weather.weather_summary,
        rainfall_type: @birthday_weather.rain_volume
      }
    end
  end

  def upload_image
    Rails.logger.info "[Upload] 开始处理图片上传请求"
    uploaded_file = params[:image]
    
    Rails.logger.debug "[Upload] 接收到的文件: #{uploaded_file.inspect}"
    
    if uploaded_file.blank?
      Rails.logger.warn "[Upload] 错误：未接收到文件"
      render json: { error: "No file received" }, status: :unprocessable_entity
      return
    end

    begin
      filename = "screenshot_#{Time.now.to_i}.png"
      upload_dir = "/Users/tangminpeng/Documents/ruby_uploads/"
      filepath = upload_dir+filename
      
      Rails.logger.info "[Upload] 准备写入文件: #{filepath}"
      
      # 检查并创建目录
      unless Dir.exist?(upload_dir)
        Rails.logger.info "[Upload] 创建上传目录: #{upload_dir}"
        FileUtils.mkdir_p(upload_dir)
      end

      # 直接保存上传的文件
      File.open(filepath, 'wb') do |f|
        f.write(uploaded_file.read)
      end
      Rails.logger.info "[Upload] 文件写入成功: #{filepath}"

      image_url = "#{request.base_url}/ruby_uploads/#{filename}"
      Rails.logger.info "[Upload] 返回图片URL: #{image_url}"
      render json: { url: image_url }
      
    rescue => e
      Rails.logger.error "[Upload] 发生异常: #{e.message}\n#{e.backtrace.join("\n")}"
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
