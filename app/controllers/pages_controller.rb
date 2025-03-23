class PagesController < ApplicationController
  def index
    @weather_texts = [
      "晴天", "多云", "阴天", "小雨", "中雨", "大雨", "雷阵雨",
      "小雪", "中雪", "大雪", "雾", "沙尘", "台风"
    ]
  end
end
