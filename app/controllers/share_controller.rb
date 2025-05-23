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
    image_data = params[:image]
    Rails.logger.info "Upload_image called"
  image_data = params[:image]
  if image_data.blank?
    Rails.logger.warn "No image data received"
    render json: { error: "No image data received" }, status: :unprocessable_entity
    return
  end

    if image_data.present?
      begin
        # base64 字符串格式通常是 "data:image/png;base64,xxxxxx"
        encoded_image = image_data.split(',')[1]
        decoded_image = Base64.decode64(encoded_image)

        # 文件名用时间戳避免重复
        filename = "screenshot_#{Time.now.to_i}.png"
        upload_dir = Rails.root.join('public', 'uploads')
        filepath = upload_dir.join(filename)

        # 创建上传目录（如果不存在）
        FileUtils.mkdir_p(upload_dir) unless Dir.exist?(upload_dir)

        # 写文件
        File.open(filepath, 'wb') do |f|
          f.write(decoded_image)
        end

        # 返回图片的可访问URL
        render json: { url: "#{request.base_url}/uploads/#{filename}" }
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: "No image data received" }, status: :unprocessable_entity
    end
  end
end
