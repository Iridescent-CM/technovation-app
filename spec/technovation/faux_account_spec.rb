require "rails_helper"

RSpec.describe FauxAccount do
  let(:faux_account) do
    FauxAccount.new(
      real_account: account,
      methods_with_return_values: methods_with_return_values
    )
  end
  let(:account) { double("Account", wibble: "", wobble: "", wubble: "") }
  let(:methods_with_return_values) { {name: "Claire", email: "claire@example.com"} }

  it "creates methods and return values based on the arguments" do
    expect(faux_account.name).to eq("Claire")
    expect(faux_account.email).to eq("claire@example.com")
  end

  it "returns nil for methods not defined when initialzing, but are defined on a real account" do
    expect(faux_account.wibble).to eq(nil)
    expect(faux_account.wobble).to eq(nil)
    expect(faux_account.wubble).to eq(nil)
  end

  it "throws an error for methods not defined on a real account or when initialzing" do
    expect { faux_account.blah_missing_method }.to raise_error(NameError)
  end
end
