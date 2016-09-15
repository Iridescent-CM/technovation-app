module FormHelper
  def extra_location_field(obj, method)
    if obj.address_details.blank?
      "hidden"
    elsif obj.public_send(method).blank?
      "showing"
    else
      "hidden"
    end
  end
end
