import _ from "lodash";

import Event from '../../app/javascript/event';
import Attendee from '../../app/javascript/attendee';

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
