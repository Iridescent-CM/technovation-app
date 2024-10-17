module Admin
  class LegalDocumentsController < AdminController
    include DatagridController

    use_datagrid with: LegalDocumentsGrid

    def void
      document = Document.find(params.fetch(:legal_document_id))

      VoidDocumentJob.perform_later(document_id: document.id)

      redirect_to admin_legal_documents_path,
        success: "Successfully scheduled a job to void the #{document.document_type} for #{document.full_name}. Please wait about a minute to see the changes reflected here."
    end

    private

    def grid_params
      grid = params[:legal_documents_grid] ||= {}

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
