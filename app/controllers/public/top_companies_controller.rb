module Public
  class TopCompaniesController < PublicController
    def index
      companies = [
        "Salesforce",
        "Adobe",
        "Google",
        "Uber",
        "Samsung",
        "Oracle",
        "AECOM",
        "HARMAN",
        "Microsoft",
        "Accenture",
        "Bank of America"
      ]

      filtered_companies = companies.select{ |company|
        company.downcase().include? params[:q].downcase()
      }

      render json: {
        attributes: filtered_companies,
      }
    end
  end
end