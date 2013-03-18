module ResponseHelpers
  def successful_response(parsed_body)
    stub(:success? => true, :parsed => parsed_body)
  end
end
