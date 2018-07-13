export default function (json) {
  this.city = json.city || "[no city]"
  this.stateCode = json.state_code || "[no state/province]"
  this.countryCode = json.country_code || "[no country/territory]"
}