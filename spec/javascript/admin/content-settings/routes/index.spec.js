import { routes } from 'admin/content-settings/routes'
import Events from 'admin/content-settings/components/Events'
import Judging from 'admin/content-settings/components/Judging'
import Notices from 'admin/content-settings/components/Notices'
import Registration from 'admin/content-settings/components/Registration'
import ScoresAndCertificates from 'admin/content-settings/components/ScoresAndCertificates'
import Surveys from 'admin/content-settings/components/Surveys'
import TeamsAndSubmissions from 'admin/content-settings/components/TeamsAndSubmissions'

describe('Admin Content & Settings - routes', () => {

  it('returns the routes used by the AdminContentSettings component', () => {
    expect(routes).toEqual([
      {
        path: '/',
        redirect: {
          name: 'registration',
        },
      },
      {
        path: '/events',
        name: 'events',
        component: Events,
      },
      {
        path: '/judging',
        name: 'judging',
        component: Judging,
      },
      {
        path: '/notices',
        name: 'notices',
        component: Notices,
      },
      {
        path: '/registration',
        name: 'registration',
        component: Registration,
      },
      {
        path: '/scores_and_certificates',
        name: 'scores_and_certificates',
        component: ScoresAndCertificates,
      },
      {
        path: '/surveys',
        name: 'surveys',
        component: Surveys,
      },
      {
        path: '/teams_and_submissions',
        name: 'teams_and_submissions',
        component: TeamsAndSubmissions,
      },
    ])
  })

})