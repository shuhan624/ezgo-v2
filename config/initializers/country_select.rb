# Return a string to customize the text in the <option> tag, `value` attribute will remain unchanged
CountrySelect::FORMATS[:tw_name] = lambda do |country|
  country.translation('zh-TW')
end
