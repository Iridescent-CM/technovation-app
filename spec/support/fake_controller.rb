class FakeController
  def redirect_to(*)
  end

  def current_scope(*)
  end

  def send(*)
  end

  def remove_cookie(*)
  end

  def set_cookie(*)
  end

  def request(*)
    OpenStruct.new({remote_ip: "0.0.0.0"})
  end
end
