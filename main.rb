if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'net/http'
require 'uri'
require 'rexml/document'
require_relative 'lib/forecast'

#Массив городов, и их кодов относительно сервиса meteoservice.ru
TOWNS_VALID = { "Запорожье" => '95',
                "Киев" => '25',
                "Херсон" => '848',
                "Харьков" => '22',
                "Одесса" => '55' }

def get_forecast_xml(town_id)
  uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{town_id}.xml")
  response = Net::HTTP.get_response(uri)
  doc = REXML::Document.new(response.body)
end

choice = ''

loop do #Опрос юзера
  puts 'Введите название города, погоду в котором желаете узнать'
  puts 'Возможно предоставить информацию о погоде в следующих городах:'

  TOWNS_VALID.each do |town| #Выводим список городов
    puts "#{town[0]}"
  end
  puts
  choice = gets.chomp

  if TOWNS_VALID.has_key?(choice) #Проверяем валидность ввода юзера
    break # Выходим из блока если ввод валидный
  else
    puts "\nНеверно указано имя города!\n---------------------------"
  end
end

doc = get_forecast_xml(TOWNS_VALID[choice])
forecasts = doc.root.elements['REPORT/TOWN'].elements.to_a

forecasts.each do |node|
  forecast = Forecast::from_xml(node)
  puts forecast.to_s
end

