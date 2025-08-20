class StateProvinces::MexicoState < State
  def format_map
    {
      "BCS" => "b.c.s.",
      "CMX" => "cdmx",
      "DIF" => "cdmx",
      "GUA" => "gto",
      "HID" => "hgo",
      "NLE" => "n.l.",
      "SLP" => "s.l.p."
    }
  end
end
