import _ from 'lodash';

import Event from '../../app/javascript/events/Event';
import Attendee from '../../app/javascript/events/Attendee';

describe('resultReadyForList', () => {
  it('ignores double entry', () => {
    const event = new Event({ id: 1 });

    const teamResp = { id: '1', assignments: [] };
    event.resultReadyForList(teamResp, event.selectedTeams);
    event.resultReadyForList(teamResp, event.selectedTeams);

    expect(_.map(event.selectedTeams, 'id')).toEqual([1]);
  });
});

describe('addTeam', () => {
  it('adds new teams', () => {
    const event = new Event({ id: 1 });

    const team1 = new Attendee({ id: '1' });
    event.addTeam(team1);

    const team2 = new Attendee({ id: '2' });
    event.addTeam(team2);

    expect(_.map(event.selectedTeams, 'id')).toEqual([1, 2]);
  });

  it('ignores already added teams', () => {
    const event = new Event({ id: 1 });

    const team = new Attendee({ id: '1' });
    event.addTeam(team);
    event.addTeam(team);

    expect(_.map(event.selectedTeams, 'id')).toEqual([1]);
  });

  it('notifies teams of the action', () => {
    const event = new Event({ id: 1 });
    const team = new Attendee({ id: '1' });

    event.addTeam(team);
    expect(team.selected).toBe(true);
  });
});

describe('removeTeam', () => {
  it('removes specified team', () => {
    const event = new Event({ id: 1 });

    const remove = new Attendee({ id: '1' });
    event.addTeam(remove);

    const keep = new Attendee({ id: '2' });
    event.addTeam(keep);

    event.removeTeam(remove);
    expect(_.map(event.selectedTeams, 'id')).toEqual([2]);
  });

  it('notifies teams of the action', () => {
    const event = new Event({ id: 1 });
    const team = new Attendee({ id: '1' });

    event.removeTeam(team);
    expect(team.selected).toBe(false);
  });
});
