import { routes } from 'admin/dashboard/routes'
import Mentors from 'admin/dashboard/components/MentorsSection'
import Students from 'admin/dashboard/components/StudentsSection'
import TopCountries from 'admin/dashboard/components/TopCountriesSection'

describe('Admin Dashboard - routes', () => {

  it('returns the routes used by the AdminDashboard component', () => {
    expect(routes).toEqual([
      {
        path: '/',
        redirect: {
          name: 'students',
        },
      },
      {
        path: '/students',
        name: 'students',
        component: Students,
      },
      {
        path: '/mentors',
        name: 'mentors',
        component: Mentors,
      },
      {
        path: '/top_countries',
        name: 'top_countries',
        component: TopCountries,
        props: {
          hideTotal: true,
        },
      },
    ])
  })

})