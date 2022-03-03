class ReportSerializer

  def initialize(report_attributes)
    @report_attributes = report_attributes
  end

  def serialize
    return {} if @report_attributes.empty?
    serialized_attributes = {}

    Flag.report_attributes_schema.each_with_index do |attribute, index|
      attr_name = attribute[:name]
      attr_label = attribute[:label]

      selection_input = @report_attributes.find do |input_name, input_value|
        input_name.include?(attr_name.to_s + '_selected')
      end

      selected = selection_input[1] == "true"

      value_input = @report_attributes.find do |input_name, input_value|
        input_name == attr_name.to_s
      end

      if Flag.details_required?(attr_name)
        value = value_input[1]
      else
        value = "No details required"
      end

      serialized_attributes[index] = {
        prompt: attr_label,
        selected: selected,
        value: value
      }
    end

    serialized_attributes
  end

end

