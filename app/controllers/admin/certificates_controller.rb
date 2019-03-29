module Admin
  class CertificatesController < AdminController
    include DatagridController

    use_datagrid with: CertificatesGrid

    private
    def grid_params
      grid = params[:certificates_grid] ||= {}
      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end
