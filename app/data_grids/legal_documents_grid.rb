class LegalDocumentsGrid
  include Datagrid

  self.batch_size = 10

  scope do
    Document.order(created_at: :desc)
  end

  column :full_name, header: "Name", mandatory: true
  column :email_address, mandatory: true
  column :document_type, header: "Document", mandatory: true

  column :status, mandatory: true do |document|
    document.status&.capitalize
  end

  column :actions, mandatory: true, html: true do |document|
    render "admin/legal_documents/actions", document: document
  end

  filter :full_name,
    header: "Name",
    filter_group: "common" do |value|
      where("full_name LIKE '%#{value}%'")
    end

  filter :email_address,
    filter_group: "common" do |value|
      where("email_address LIKE '%#{value}%'")
    end

  filter :status,
    :enum,
    select: Document.statuses.transform_keys(&:capitalize),
    filter_group: "common",
    html: {
      class: "and-or-field"
    } do |value|
    where(status: value)
  end
end
