startDate=$1

authors="author:aferrero2707 author:pillot author:aphecetche author:dstocco author:javierecc"
#authors="author:aphecetche"

q="
query {
    search(type: ISSUE,
            last: 100,
            query:\"merged:>=$startDate repo:AliceO2Group/AliceO2 is:pr $authors\") 
            {
              edges {
                node {
                  ... on PullRequest {
                  number
                  title
                  mergedAt
                  author {
                    login }
                  }
                }
              }
            }
}"
                                     
jqfilter='.data.search.edges 
|=sort_by(.node.mergedAt) 
| .data.search.edges 
| reverse 
| .[]  
|
  (.node.number| tostring )+" " +
  (.node.mergedAt|fromdate|strftime("%Y-%m-%d")) + " " + .node.title + " (" +
  .node.author.login +")"'

gh api graphql --paginate -f query=$q | jq -r $jqfilter

