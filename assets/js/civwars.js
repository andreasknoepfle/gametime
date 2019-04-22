import Gametime from './gametime';
import pickBy from 'lodash/pickBy';
import sample from 'lodash/sample';
import map from 'lodash/map';

const gameName = 'civwars';
const aiName = 'maltes-ai';

Gametime.register(gameName, aiName, (state, player_id) => {
  const yourVillages = pickBy(state.villages, (village) => {
    return village.owner !== player_id;
  });

  const myVillages = pickBy(state.villages, (village) => {
    return village.owner === player_id && village.units > 30
  });

  console.log("myVillages", Object.keys(myVillages).length);
  console.log("yourVillages", Object.keys(yourVillages).length);

  if (Object.keys(yourVillages).length > 0) {
    const actions =
      map(myVillages, (_village, name) => ({
        from: name,
        to: sample(Object.keys(yourVillages)),
      }));

    return actions;
  } else {
    return [];
  }
});

console.log('ai loaded', aiName);
