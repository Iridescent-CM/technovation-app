import _ from "lodash";

import Attendee from 'ra/events/Attendee';

test('assignedTeamFoundInEvent adds teams to assignedTeams list', () => {
  const team = new Attendee({ id: 1 })
  const judge = new Attendee({ id: 2, email: 'foo' })

  judge.assignedTeamFoundInEvent(team)

  expect(_.map(judge.assignedTeams, 'id')).toEqual([1])
  expect(_.map(team.assignedJudges, 'id')).toEqual([2])
})