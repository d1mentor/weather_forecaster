#Расшифровку получаемых данных смотрите в README.txt
require 'Date'

class Forecast
  #облачность
  CLOUDINESS = { "-1" => 'Туман',
                   "0" => 'Ясно',
                   "1" => 'Малооблачно',
                   "2" => 'Облачно',
                   "3" => 'Пасмурно'}.freeze
  #Осадки
  PRECIPITATION = {"3" => 'Смешанные',
                     "4" => 'Дождь',
                     "5" => 'Ливень',
                     "6" => 'Снег',
                     "7" => 'Снег',
                     "8" => 'Гроза',
                     "9" => 'Нет данных',
                     "10" => 'Без осадков'}.freeze
  #Часть дня
  TOD = ['Ночь', 'Утро', 'День', 'Вечер'].freeze

  def initialize(args)
    @forecast_date = args[:forecast_date]
    @temperature_min = args[:temperature_min]
    @temperature_max = args[:temperature_max]
    @cloudiness = args[:cloudiness]
    @precipitation = args[:precipitation]
    @wind_max = args[:wind_max]
    @wind_min = args[:wind_min]
    @time_of_day = args[:tod]
  end

  def self.from_xml(forecast) # <- Получает блок xml, парсит его, и создает обьект
    day = forecast.attributes['day']
    month = forecast.attributes['month']
    year = forecast.attributes['year']

    args = {
      forecast_date: Date.parse("#{day}.#{month}.#{year}"),
      temperature_min: forecast.elements['TEMPERATURE'].attributes['min'].to_i,
      temperature_max: forecast.elements['TEMPERATURE'].attributes['max'].to_i,
      cloudiness: CLOUDINESS[forecast.elements['PHENOMENA'].attributes['cloudiness']],
      precipitation: PRECIPITATION[forecast.elements['PHENOMENA'].attributes['precipitation']],
      wind_max: forecast.elements['WIND'].attributes['max'].to_i,
      wind_min: forecast.elements['WIND'].attributes['min'].to_i,
      tod: TOD[forecast.attributes['tod'].to_i]
    }

    new(args)
  end

  def to_s # <- Возвращает прогноз в виде строки
    <<~END
      Прогноз погоды на #{@time_of_day} #{@forecast_date}:
      Облачность:#{@cloudiness}
      Температура в цельсиях: от #{@temperature_min} до #{@temperature_max}
      Скорость ветра: от #{@wind_min} до #{@wind_max}
      Осадки:#{@precipitation} \n
    END
  end
end
