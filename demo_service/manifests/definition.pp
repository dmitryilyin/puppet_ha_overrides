define demo_service::definition (
  $message = 'without ha support',
) {
  notify { $title :
    message => "Demo_def: ${title} -> ${message}",
  }
}
