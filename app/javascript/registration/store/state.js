export default {
  isReady: false,
  isLocked: false,
  apiRoot: 'registration',
  apiMethod: 'post',
  wizardToken: null,
  token: null,

  termsAgreed: null,
  termsAgreedDate: '',

  birthYear: null,
  birthMonth: null,
  birthDay: null,

  cutoff: new Date(2020, 7, 1),

  profileChoice: null,

  city: null,
  state: null,
  country: null,

  firstName: null,
  lastName: null,

  genderIdentity: null,
  schoolCompanyName: null,
  jobTitle: null,
  mentorType: null,
  expertiseIds: [],

  referredBy: null,
  referredByOther: null,

  months: [
    { label: "01 - January", value: "1" },
    { label: "02 - February", value: "2" },
    { label: "03 - March", value: "3" },
    { label: "04 - April", value: "4" },
    { label: "05 - May", value: "5" },
    { label: "06 - June", value: "6" },
    { label: "07 - July", value: "7" },
    { label: "08 - August", value: "8" },
    { label: "09 - September", value: "9" },
    { label: "10 - October", value: "10" },
    { label: "11 - November", value: "11" },
    { label: "12 - December", value: "12" },
  ],

  email: '',
}