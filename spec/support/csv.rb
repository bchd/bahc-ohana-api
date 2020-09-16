module CSVHelpers
  def replace_variables_in_csv(path, variables)
    content = File.read(path)

    content = variables.reduce(content) do |content, (key, value)|
      content.gsub("{#{key.upcase}}", value.to_s)
    end

    tmpfile = Tempfile.new
    tmpfile.write(content)
    tmpfile.rewind
    tmpfile.path
  end
end
