startDate=$1

authors="author:pillot author:aphecetche author:dstocco author:grasseau author:aferrero2707 author:mwinn2 author:javierrc"
#authors="author:aferrero2707 author:pillot author:aphecetche author:dstocco author:javierecc author:grasseau author:mwinn2"

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
  "[" + (.node.number| tostring ) + 
  "](https://github.com/AliceO2Group/AliceO2/pull/" + 
  (.node.number| tostring) + ") "+
  (.node.mergedAt|fromdate|strftime("%Y-%m-%d")) + " " + .node.title + " (" +
  .node.author.login +")"'

gh api graphql --paginate -f query=$q | jq -r $jqfilter

