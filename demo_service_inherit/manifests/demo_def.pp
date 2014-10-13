define demo_service_inherit::demo_def(
) {
  Notify <| title == $title |> {
    message => 'now with ha support',
  }
}
