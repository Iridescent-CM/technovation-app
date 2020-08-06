import Attendee from 'chapter_ambassador/events/Attendee'

test('assignedTeamFoundInEvent adds teams to assignedTeams list', () => {
  const team = new Attendee({ id: 1 })
  const judge = new Attendee({ id: 2, email: 'foo' })

  judge.assignedTeamFoundInEvent(team)

  expect(judge.assignedTeams.map((team) => team.id)).toEqual([1])
  expect(team.assignedJudges.map((judge) => judge.id)).toEqual([2])
})
