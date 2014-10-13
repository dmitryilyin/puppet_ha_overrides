define service_ha_override::demo_def () {
  Notify <| title == $title |> {
    message => 'override ha support',
  }
}
