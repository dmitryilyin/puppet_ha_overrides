define demo_service::demo_def (
  $message = 'without ha',
) {
  notify { $title :
    message => "Demo_def: ${title} -> ${message}",
  }
}
