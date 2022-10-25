return {
  parse("match", [[
  let result = match T {
      Ok(data) => data,
      Err(e) => return Err(e),
  };
  ]]),
}
