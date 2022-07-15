return {
	parse("iferr", [[
  if err != nil {
    return err
  }
  ]]),
	parse("iferrwrap", [[
  if err != nil {
    return fmt.Errorf("error: %w", err)
  }
  ]]),
	parse("pfmt", "fmt.Printf(\"%+v\\n\", )"),
}
