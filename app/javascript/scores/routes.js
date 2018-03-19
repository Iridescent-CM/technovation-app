import Ideation from "./Ideation"
import Technical from "./Technical"
import Pitch from "./Pitch"

export default [
  { path: '/', redirect: { name: 'ideation' } },
  { path: '/ideation', name: 'ideation', component: Ideation },
  { path: '/technical', name: 'technical', component: Technical },
  { path: '/pitch', name: 'pitch', component: Pitch },
]
