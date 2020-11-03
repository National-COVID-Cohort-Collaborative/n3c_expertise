<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="projects" dataSource="jdbc/N3CExpertiseTagLib">
select
    jsonb_pretty(jsonb_agg(pubs))
from
     	(select orcid,first_name,last_name,doi,title,created::date
     			from n3c_expertise.profile natural join n3c_expertise.crossref_map natural join covid_crossref.research_output natural join covid_crossref.title
     			order by created desc
     	) as pubs
;
</sql:query>
{
    "headers": [
        {"value":"title", "label":"Title"},
        {"value":"last_name", "label":"Researcher"},
        {"value":"created", "label":"Date"}
    ],
    "rows" : 
<c:forEach items="${projects.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
}

			