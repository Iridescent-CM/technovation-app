module ApplicationGrid
  def self.included(base)
    base.include Datagrid
    base.batch_size = 1_000
  end
end
