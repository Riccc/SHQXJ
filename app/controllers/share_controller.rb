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
  end
end
