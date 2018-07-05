import { routes } from 'admin/dashboard/routes'
import Mentors from 'admin/dashboard/components/MentorsSection'
import Students from 'admin/dashboard/components/StudentsSection'
import Participants from 'admin/dashboard/components/ParticipantsSection'

describe('Admin Dashboard - routes', () => {

  it('returns the routes used by the AdminDashboard component', () => {
    expect(routes).toEqual([
      { path: '/', redirect: { name: 'students' }},
      { path: '/students', name: 'students', component: Students },
      { path: '/mentors', name: 'mentors', component: Mentors },
      { path: '/participants', name: 'participants', component: Participants },
    ])
  })

})