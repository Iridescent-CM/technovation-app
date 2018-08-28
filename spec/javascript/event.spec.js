import _ from "lodash";

import Event from 'ra/events/Event';
import Attendee from 'ra/events/Attendee';

test('resultReadyForList ignores double entry', () => {
  let event = new Event({ id: 1 })

  const teamResp = { id: "1", assignments: {} }
  event.resultReadyForList(teamResp, event.selectedTeams)
  event.resultReadyForList(teamResp, event.selectedTeams)

  expect(_.map(event.selectedTeams, "id")).toEqual([1])
})

test('resultReadyForList appends assignments', () => {
  let event = new Event({ id: 1 })

  const teamResp = { id: "1", assignments: { judge_ids: [1, 2] } }
  const judgeResp = { id: "2", assignments: { team_ids: [1] } }

  event.resultReadyForList(teamResp, event.selectedTeams)
  event.resultReadyForList(judgeResp, event.selectedJudges)

  const team = event.selectedTeams[0]
  const judge = event.selectedJudges[0]

  expect(_.map(team.assignedJudges, "id")).toEqual([2])
  expect(_.map(judge.assignedTeams, "id")).toEqual([1])
})

test('addTeam adds new teams', () => {
  let event = new Event({ id: 1 });

  const team1 = new Attendee({ id: "1" });
  event.addTeam(team1);

  const team2 = new Attendee({ id: "2" });
  event.addTeam(team2);

  expect(_.map(event.selectedTeams, "id")).toEqual([1, 2]);
});

test('addTeam ignores already added teams', () => {
  let event = new Event({ id: 1 });

  const team = new Attendee({ id: "1" });
  event.addTeam(team);
  event.addTeam(team);

  expect(_.map(event.selectedTeams, "id")).toEqual([1]);
});

test('removeTeam removes specified team', () => {
  let event = new Event({ id: 1 });

  const remove = new Attendee({ id: "1" });
  event.addTeam(remove);

  const keep = new Attendee({ id: "2" });
  event.addTeam(keep);

  event.removeTeam(remove);
  expect(_.map(event.selectedTeams, "id")).toEqual([2]);
});

test('addTeam/removeTeam notifies teams of the action', () => {
  let event = new Event({ id: 1 });
  const team = new Attendee({ id: "1" });

  event.addTeam(team);
  expect(team.selected).toBe(true);

  event.removeTeam(team);
  expect(team.selected).toBe(false);
});

describe('findTeam', () => {
  let event
  let team1
  let team2
  let team3

  beforeEach(() => {
    event = new Event({ id: 1 })
    team1 = new Attendee({ id: '1' })
    team2 = new Attendee({ id: '2' })
    team3 = new Attendee({ id: '3' })

    event.addTeam(team1)
    event.addTeam(team2)
    event.addTeam(team3)
  })

  it('returns the team if found', () => {
    let foundTeam = event.findTeam('1')

    expect(foundTeam).toEqual(team1)

    foundTeam = event.findTeam('2')

    expect(foundTeam).toEqual(team2)

    foundTeam = event.findTeam('3')

    expect(foundTeam).toEqual(team3)
  })

  it('returns undefined if not found', () => {
    const foundTeam = event.findTeam('6')

    expect(foundTeam).toBeUndefined()
  })
})

describe('findJudge', () => {
  let event
  let judge1
  let judge2
  let judge3

  beforeEach(() => {
    event = new Event({ id: 1 })
    judge1 = new Attendee({ id: '1' })
    judge2 = new Attendee({ id: '2' })
    judge3 = new Attendee({ id: '3' })

    event.addJudge(judge1)
    event.addJudge(judge2)
    event.addJudge(judge3)
  })

  it('returns the team if found', () => {
    let foundJudge = event.findJudge('1')

    expect(foundJudge).toEqual(judge1)

    foundJudge = event.findJudge('2')

    expect(foundJudge).toEqual(judge2)

    foundJudge = event.findJudge('3')

    expect(foundJudge).toEqual(judge3)
  })

  it('returns undefined if not found', () => {
    const foundJudge = event.findJudge('6')

    expect(foundJudge).toBeUndefined()
  })
})