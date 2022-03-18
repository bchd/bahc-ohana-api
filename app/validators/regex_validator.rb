class RegexValidator < ActiveModel::EachValidator
  def regex_validate_each(regex, err_msg, record, attribute, value)
    return if value&.match?(regex)

    record.errors.add(attribute, message: err_msg)
  end
end
