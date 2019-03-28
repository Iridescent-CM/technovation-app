module Registration
  class TopCompaniesController < RegistrationController
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
        Cisco\ Customer\ Experience\ (CX)
      }

      render json: {
        attributes: companies,
      }
    end
  end
end