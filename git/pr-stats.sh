get_first_cursor() {
  jqfilter='.data.repository.pullRequests.edges| .[0] .cursor'
  echo $1 | jq -r $jqfilter
}

get_last_cursor() {
  jqfilter='.data.repository.pullRequests.edges| .[-1] .cursor'
  echo $1 | jq -r $jqfilter
}

do_query() {
  if [ -n "$1" ]; then
    before=", before: \"$1\""
  else 
    before=""
  fi
  q="
  {
    repository(owner: \"AliceO2Group\", name: \"AliceO2\") {
      name
      pullRequests(last: 100, states: MERGED $before) {
        edges {
          cursor
          node {
            number
            author {
              login
            }
            createdAt
            mergedAt
          }
        }
      }
    }
  }
  "
  echo $(gh api graphql --paginate -f query=$q)
}

lastCursor=''

rm pr-stats.json

for index in {0..10} 
do

result=$(do_query $lastCursor)

lastCursor=$(get_first_cursor $result)

echo $result >> pr-stats.json

done

echo "pr number,lead time in days,author" > pr-stats.csv
cat pr-stats.json | jq -r '.data.repository.pullRequests.edges| .[] | (.node.number|tostring) + "," + (((.node.mergedAt|fromdate)-(.node.createdAt|fromdate))/3600/24|tostring) + "," + .node.author.login' >> pr-stats.csv

cat pr-stats.csv
