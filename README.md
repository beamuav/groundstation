# Flight Simulator: Ground Control to Major Tom

This is my entry in [Phoenix Phrenzy](https://phoenixphrenzy.com), showing off what [Phoenix](https://phoenixframework.org/) and [LiveView](https://github.com/phoenixframework/phoenix_live_view) can do.

![Ground Control to Major Tom](https://groundstation.gigalixirapp.com/)

This is a simple Flight Simulator written in Elixir. The flight simulation takes place completely on the server side, where Phoenix Live View sends DOM updates over a websocket at appoximately 30fps (1 tick every ~30ms).

Every client browser will get their own world with your very own plane in it, so enjoy flying around Sydney (you'll start on the main runway of Sydney International airport).

Have fun!

## Flight Manual

### Keyboard Commands

- `wasd` or `Arrow keys` controls the planes' roll and pitch
  - `up` or `w` points the plane down toward the ground
  - `down` or `s` points the plane up into the air
  - `left`/`right` or `a`/`d` banks left and right
- `,`/`.` turns the rudder left / right (yaw control - useful for taxiing on a runway)
- `-`/`=` increase / decrease speed
- `Esc` reset the simulation
- `Space` partially restore the plane to level flight

## Implementation Highlights

- The **Artificial Horizon** and **Compass** are rendered using hand-written SVG which is updated directly by Live View.
- The **Map** is implemented using Leaflet, a JS interactive mapping library https://leafletjs.com/
- The **3D Cockpit View** is implemented using the ESRI library and the ArcGIS SDK https://developers.arcgis.com/javascript/latest/api-reference/esri-views-SceneView.html
- Both the Map and Cockpit view are updated using Live View Hooks which runs JS functions on DOM updates from the server

## Limitations

- It requires keyboard input to control the plane, so this probably won't work well on mobile devices (at least I haven't tested it)
- This is running on a free tier Gigalixir deployment so if lots of people are using this it's going to not work that well
- If you want to experience it super smooth then please run it locally to spare some bandwidth
- I tried getting the 3d camera to tilt but it wouldn't point up reliably, and often flipped upside down and be generally janky so our view stays level

## Contributing

Bug reports and PRs welcome!

## Background

This app is the starting point of building the Ground Station application for the UAV Challenge 2020 (https://uavchallenge.org/medical-rescue/). For this challenge, the BEAM UAV team will be attempting to complete the challenge using 2 drones and controlling them with as much Elixir and the BEAM for the software components as possible.

I wrote the Flight Simulator so this would be a bit more interactive and fun for a more general audience, as well as showing off the power and simplicity of Phoenix Live View.

## Thanks

Special thanks to Robin Hilliard for the motivation to build this and some guidance around simplifying the maths of the simulator. Also thanks to David Parry and Rufus Post for moral support.

Lastly I really appreciate all the hard work that's gone into Live View, it's a pretty amazing bit of technology that we'll hopefully see a lot more of in the coming years. So thanks Chris McCord and Jose Valim!


# Phrenzy Instructions

Fork this repo and start build an application! See [Phoenix Phrenzy](https://phoenixphrenzy.com) for details.

Note: for development, you'll need Elixir, Erlang and Node.js. If you use the [asdf version manager](https://github.com/asdf-vm/asdf) and install the [relevant plugins](https://asdf-vm.com/#/plugins-all?id=plugin-list), you can install the versions specified in `.tool-versions` with `asdf install`.

## Deployment

How you deploy your app is up to you. A couple of the easiest options are:

- Heroku ([instructions](https://hexdocs.pm/phoenix/heroku.html))
- [Gigalixir](https://gigalixir.com/) (doesn't limit number of connections)

## The Usual README Content

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: http://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
