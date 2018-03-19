import Ideation from "./Ideation"
import Technical from "./Technical"
import Pitch from "./Pitch"
import Entrepreneurship from "./Entrepreneurship"
import Overall from "./Overall"

export default [
  { path: '/', redirect: { name: 'ideation' } },
  { path: '/ideation', name: 'ideation', component: Ideation },
  { path: '/technical', name: 'technical', component: Technical },
  { path: '/pitch', name: 'pitch', component: Pitch },
  {
    path: '/entrepreneurship',
    name: 'entrepreneurship',
    component: Entrepreneurship,
  },
  { path: '/overall', name: 'overall', component: Overall },
]
