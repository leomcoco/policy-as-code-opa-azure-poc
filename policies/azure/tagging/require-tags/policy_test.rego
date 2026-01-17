package azure.tagging.require_tags

test_missing_tag_denies {
  in := {"resource": {"tags": {"ambiente": "prod"}}}
  count(deny with input as in) == 1
  (deny["Missing required tag: centro_de_custo"] with input as in)
}

test_all_tags_allows {
  in := {"resource": {"tags": {"ambiente": "prod", "centro_de_custo": "123"}}}
  count(deny with input as in) == 0
}

test_no_tags_denies {
  in := {"resource": {}}
  count(deny with input as in) == 2
}
