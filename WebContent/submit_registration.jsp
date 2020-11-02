<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>
<c:if test="${empty user_email}">
    <c:set scope="session" var="not_logged_in" value="t"/>
    <c:redirect url="index.jsp"/>
</c:if>

<n3c:registration email="${user_email}">
	<n3c:registrationOfficialFirstName officialFirstName="${param.official_first_name}" />
	<n3c:registrationOfficialLastName officialLastName="${param.official_last_name}" />
	<n3c:registrationOfficialFullName officialFullName="${param.official_full_name}" />
	<n3c:registrationFirstName firstName="${param.first_name}" />
	<n3c:registrationLastName lastName="${param.last_name}" />
	<n3c:registrationInstitution institution="${param.institution}" />
	<n3c:registrationOrcidId orcidId="${param.orcid}" />
	<n3c:registrationGsuiteEmail gsuiteEmail="${param.gsuite}" />
	<n3c:registrationSlackId slackId="${param.slack}" />
	<n3c:registrationGithubId githubId="${param.github}" />
	<n3c:registrationTwitterId twitterId="${param.twitter}" />
	<n3c:registrationExpertise expertise="${param.expertise}" />
	<n3c:registrationTherapeuticArea therapeuticArea="${param.therapeutic}" />
	<n3c:registrationAssistantEmail assistantEmail="${param.assistant}" />
	<n3c:registrationEnclave enclave="${not empty param.enclave}" />
	<n3c:registrationWorkstreams workstreams="${not empty param.workstreams}" />
	<n3c:registrationUpdatedToNow />
</n3c:registration>

<c:choose>
	<c:when	test='${n3c:membershipExists(user_email,"analytics") and empty param.analytics}'>
		<n3c:deleteMembership email="${user_email}" label="analytics" />
	</c:when>
	<c:when	test='${not n3c:membershipExists(user_email,"analytics") and not empty param.analytics}'>
		<n3c:membership email="${user_email}" label="analytics">
			<n3c:membershipJoinedToNow />
		</n3c:membership>
	</c:when>
</c:choose>

<c:choose>
	<c:when	test='${n3c:membershipExists(user_email,"governance") and empty param.governance}'>
		<n3c:deleteMembership email="${user_email}" label="governance" />
	</c:when>
	<c:when	test='${not n3c:membershipExists(user_email,"governance") and not empty param.governance}'>
		<n3c:membership email="${user_email}" label="governance">
			<n3c:membershipJoinedToNow />
		</n3c:membership>
	</c:when>
</c:choose>

<c:choose>
	<c:when	test='${n3c:membershipExists(user_email,"phenotype") and empty param.phenotype}'>
		<n3c:deleteMembership email="${user_email}" label="phenotype" />
	</c:when>
	<c:when	test='${not n3c:membershipExists(user_email,"phenotype") and not empty param.phenotype}'>
		<n3c:membership email="${user_email}" label="phenotype">
			<n3c:membershipJoinedToNow />
		</n3c:membership>
	</c:when>
</c:choose>

<c:choose>
	<c:when	test='${n3c:membershipExists(user_email,"harmonization") and empty param.harmonization}'>
		<n3c:deleteMembership email="${user_email}" label="harmonization" />
	</c:when>
	<c:when	test='${not n3c:membershipExists(user_email,"harmonization") and not empty param.harmonization}'>
		<n3c:membership email="${user_email}" label="harmonization">
			<n3c:membershipJoinedToNow />
		</n3c:membership>
	</c:when>
</c:choose>

<c:choose>
	<c:when	test='${n3c:membershipExists(user_email,"synthetic") and empty param.synthetic}'>
		<n3c:deleteMembership email="${user_email}" label="synthetic" />
	</c:when>
	<c:when	test='${not n3c:membershipExists(user_email,"synthetic") and not empty param.synthetic}'>
		<n3c:membership email="${user_email}" label="synthetic">
			<n3c:membershipJoinedToNow />
		</n3c:membership>
	</c:when>
</c:choose>

<c:redirect url="profile.jsp" />
