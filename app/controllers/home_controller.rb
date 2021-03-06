class HomeController < ApplicationController

  def index
    @holiday_around = Holiday.holiday_around.group_by{|hol| hol.date.month }
  end

  def admin
    @admin = {name: 'Mr.Administrator', role: 'admin'}
    @holiday = Holiday.new
    @holidays = Holiday.all
  end

  def create_holiday
    @holiday = Holiday.new(params[:holiday]).merge!(date: params[:holiday][:date].to_date)
    @holiday.save!
    redirect_to admin_path
  end

  def holidays
    start_date = DateTime.strptime(params[:start],'%s')
     end_date =  DateTime.strptime(params[:end],'%s')
     holiday_dates = Holiday.holiday_between start_date, end_date
     holiday_dates_hash = [Holiday::OFF_DAYS, hash_from_holiday_object(holiday_dates)]
    render :json => holiday_dates_hash
  end

  private
  def hash_from_holiday_object(holidays)
    h =  Hash.new
    holidays.each do |holiday|
      h[holiday.date.to_date] = holiday.name
    end
    h
  end
end
