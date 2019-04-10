import Gametime from 'gametime';
import pickBy from 'lodash/pickBy';
import sample from 'lodash/sample';

const me = 'maltes-ai';

Gametime.register(me, (state, player_id) => {
  console.log(state);

  const your_villages = pickBy(state.villages, village =>
    village.owner !== player_id
  )

  const my_villages = pickBy(state.villages, village =>
    village.owner === player_id && village.units > 30
  );

  return
  my_villages.map(name => {
    from: name
    to: sample(your_villages).name,
  });
});
