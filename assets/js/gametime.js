import {Socket} from "phoenix";

export default {
  register: (gameName, aiName, advance) => {
    console.log("register");
    let socket = new Socket("/socket", {params: {}});

    socket.connect();

    let channel = socket.channel(`game:${gameName}`, { name: document.getElementById("player").innerHTML });

    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) });

    channel.on("tell", resp => {
      console.log("tell", resp);

      const { state, player_id } = resp;

      let actions = advance(state, player_id);
      console.log("act", actions);

      channel
        .push("act", { actions })
        .receive("thanks", resp => console.log("thanks"));
    });
  }
};
