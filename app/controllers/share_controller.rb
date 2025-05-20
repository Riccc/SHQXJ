class ShareController < ApplicationController
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
    require 'rqrcode'
  @share_url = "https://www.weather-museum.cn/ruby/share/show?name="+@name+"&birthday="+@birthday+"&chosen_date="+@chosen_date+"&low_temp="+@low_temp+"&high_temp="+@high_temp+"&selected_text_content="+@selected_text_content+"&chosen_img="+@chosen_img+"&chosen_text="+@chosen_text
  @qr_svg = RQRCode::QRCode.new(@share_url).as_svg(
    offset: 10,
    color: '000',
    shape_rendering: 'crispEdges',
    module_size: 1.5
  ).html_safe
  end
end
