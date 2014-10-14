define demo_service_ha::definition (
) {
  Notify <| title == $title |> {
    message => 'now with ha support',
  }
}
