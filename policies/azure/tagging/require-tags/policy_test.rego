package azure.tagging.require_tags

test_missing_tag_denies {
  input := {"resource": {"tags": {"ambiente": "prod"}}}
  count(deny with input as input) == 1
}

test_all_tags_allows {
  input := {"resource": {"tags": {"ambiente": "prod", "centro_de_custo": "123"}}}
  count(deny with input as input) == 0
}
