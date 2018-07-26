module Public
  class TopCompaniesController < PublicController
    def index
      companies = %w{
        Salesforce
        Adobe
        Google
        Uber
        Samsung
        Oracle
        AECOM
        HARMAN
        Microsoft
        Accenture
        Bank\ of\ America
      }

      render json: {
        attributes: companies,
      }
    end
  end
end