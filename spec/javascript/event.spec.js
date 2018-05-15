import _ from "lodash";

import Event from '../../app/javascript/ra/events/Event';
import Attendee from '../../app/javascript/ra/events/Attendee';

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
