class NullTechnicalChecklist < NullObject
  def new_record?; false; end
  def started?; false; end
  def total_points; 0; end
  def total_technical_components; 0; end
  def total_database_components; 0; end
  def total_mobile_components; 0; end
  def completed_pics_of_process?; false; end

  def technical; []; end
  def database; []; end
  def mobile; []; end
  def process; []; end
  def paranoid?; false; end
end
