<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<!DOCTYPE html>
<c:if test="${empty user_email}">
    <c:set scope="session" var="not_logged_in" value="t"/>
    <c:redirect url="index.jsp"/>
</c:if>
<html>
	<jsp:include page="head.jsp" flush="true" />

<style type="text/css" media="all">
	@import "resources/n3c_login_style.css";
@import "<util:applicationRoot/>/resources/autocomplete.css";
</style>

<body>

	<jsp:include page="navbar.jsp" flush="true" />
	
	<div class="container center-box shadow-border">
    	<h2 class="header-text"><img src="images/n3c_logo.png" class="n3c_logo_header" alt="N3C Logo">N3C & CD2H Registration</h2>
    	
    	<n3c:registration email="${user_email}">
    	
    	<form name="registration" method='POST' action='submit_registration.jsp' autocomplete="off" onsubmit="return validateForm()" >
  			<div class="form-group row">
    			<label for="email" class="col-sm-2 col-form-label">Email</label>
    			<div class="col-sm-10">
      				<input name="email" type="text" readonly class="form-control-plaintext" id="email" value="${user_email}">
    			</div>
    			<label for="" class="required col-sm-2 col-form-label"><i style="color:#adaeb1;">required fields:</i> </label>
  			</div>
  			<div class="form-group row">
    			<label for="first_name" class="required col-sm-2 col-form-label">First Name</label>
                <style>.required:after { content:" *"; color: red; } </style>
    			<div class="col-sm-10">
      				<input name="first_name" type="text" class="form-control" id="first_name" value="${n3c:registrationFirstNameValue()}">
    			</div>
  			</div>
  			<div class="form-group row">
    			<label for="last_name" class="required col-sm-2 col-form-label">Last Name</label>
    			<div class="col-sm-10">
      				<input name="last_name" type="text" class="form-control" id="last_name" value="${n3c:registrationLastNameValue()}">
    			</div>
  			</div>
  			<div class="form-group row">
    			<label for="institution" class="required col-sm-2 col-form-label">Institution</label>
    			<div class="col-sm-10">
      				<input name="institution" type="text" class="form-control" id="institution" value="${n3c:registrationInstitutionValue()}">
      				<c:if test="${n3c:registrationOfficialInstitutionValue() != 'login.gov' && n3c:registrationOfficialInstitutionValue() != 'NIH' }">
		                <sql:query var="rors" dataSource="jdbc/N3CLoginTagLib">
		                    select institutionid,duaexecuted from n3c_admin.dua_status where official_institution = ?
		                    <sql:param><n3c:registrationOfficialInstitution/></sql:param>
		                </sql:query>
		                <c:forEach items="${rors.rows}" var="row" varStatus="rowCounter">
		                	<c:set var='found' value='yes'/>
		                	<c:set var='executed' value='${row.duaexecuted}'/>
		                </c:forEach>
		                <c:choose>
		                <c:when test="${empty found}">
	                		<p><b>Please Note:</b> The organization name returned by your login does not match those we have on file.
	                		Please allow 1-3 business days for us to match the name your institution returned to our list.
	                		You will receive an email notifying you of the issue being resolved.</p>
		                </c:when>
		                <c:when test="${empty executed}">
		                	<p><b>Please Note:</b> Your organization has not yet executed the required Data Use Agreement (DUA) with NCATS.
		                	You account request will be held in the pending queue until the DUA is executed.  You will receive details
		                	regarding your account and login procedures at that time.</p>
		                </c:when>
		                <c:otherwise>
		                	<p>Your organization has already executed the required Data Use Agreement (DUA) with NCATS.</p>
		                </c:otherwise>
		                </c:choose>
      				</c:if>
    			</div>
  			</div>


           <input style="width:16px; height:16px;" type="checkbox" id="enclave" name="enclave" value="enclave" onclick="enclaveFunction()" <c:if test="${n3c:registrationEnclaveValue()}">checked</c:if> > <label for="enclave" class="accent-text" style="font-size:20px; font-weight:500; padding-left:10px; margin-top:30px;">Access to the N3C Enclave <span style="font-size: 1rem; font-weight:300; color:#333;"> — Check this box to request an N3C Data Enclave account</span></label><br>
            
            <div id="enclave-div" style="display:<c:choose><c:when test="${n3c:registrationEnclaveValue()}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;">
                <p style="font-style:italic;">Your request for an N3C Data Enclave account will be submitted for approval. You will receive an email containing further instructions and information on accessing the N3C Data Enclave shortly.</p>
                <p>Please provide these additional details to enhance your ability to collaborate and be credited for contributions:</p>
            <div class="form-group row">
                <label for="orcid" class=" required col-sm-2 col-form-label">ORCiD ID</label>
                <div class="col-sm-10">
                    <input name="orcid" type="text" class="form-control" id="orcid" value="${n3c:registrationOrcidIdValue()}">
	                <sql:query var="orcids" dataSource="jdbc/N3CLoginTagLib">
	                    select distinct person.orcid_id,given_names,family_name,organization
	                    from orcid.person left join orcid.employment on person.id=employment.id
	                    where end_year is null and lower(family_name) = lower(?) and lower(given_names) = lower(?);
	                    <sql:param><n3c:registrationOfficialLastName/></sql:param>
	                    <sql:param><n3c:registrationOfficialFirstName/></sql:param>
	                </sql:query>
	                <c:forEach items="${orcids.rows}" var="row" varStatus="rowCounter">
	                	<c:if test="${rowCounter.index == 0}">Possible matches:<br/></c:if>
	                    <input type="radio" id="orcid_choice" name="orcid_choice" value="${row.orcid_id}" onclick="orcidFunction()" >
	                    <label for="orcid_choice">${row.orcid_id} - ${row.family_name}, ${row.given_names} (${row.organization})</label><br>
	                </c:forEach>
	                <p class="supplemental-question-info">We use ORCiD Person iDs to credit contributions and to disambiguate people. An ORCiD is required to be an author on publications with N3C
	                and is required to access the N3C secure data enclave. Getting an ORCiD is free at <a href="http://orcid.org" target="_blank">orcid.org</a>.</p>
                </div>
            </div>
            <div class="form-group row">
                <label for="expertise" class="col-sm-2 col-form-label">Expertise</label>
                <div class="col-sm-10">
                    <input name="expertise" type="text" class="form-control" id="expertise" value="${n3c:registrationExpertiseValue()}">
                </div>
            </div>
            <div class="form-group row" style="margin-bottom:65px;">
                <label for="therapeutic" class="col-sm-2 col-form-label">Therapeutic Area (for clinicians)</label>
                <div class="col-sm-10">
                    <input name="therapeutic" type="text" class="form-control" id="therapeutic" value="${n3c:registrationTherapeuticAreaValue()}">
                </div>
            </div>
            </div>

           <input style="width:16px; height:16px;" type="checkbox" id="workstreams" name="workstreams" value="workstreams" onclick="workstreamFunction()" <c:if test="${n3c:registrationWorkstreamsValue()}">checked</c:if>> <label for="workstream" class="accent-text" style="font-size:20px; font-weight:500; padding-left:10px;">Participate in N3C Workstreams<span style="font-size: 1rem; font-weight:300; color:#333;"> — Check this box to contribute to the work being done by N3C</span></label><br>

				<div id="workstream-div" style="display: <c:choose><c:when test="${n3c:registrationWorkstreamsValue()}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;">
					<div class="form-group row">
						<label for="gsuite" class="col-sm-2 col-form-label">GSuite (GMail) ID</label>
						<div class="col-sm-10">
							<input name="gsuite" type="text" class="form-control" id="gsuite" value="${n3c:registrationGsuiteEmailValue()}">
							<p class="supplemental-question-info">We use Google Drive, Docs, and Sheets to share information. <strong class="accent-text">PLEASE ENTER THE ADDRESS YOU WILL USE TO ACCESS GOOGLE DRIVE.</strong>
							If you do NOT have any address with which you currently can use Google Drive, Docs, or Sheets, NCATS is able to provide one for you.
							If this is you, please contact <a href="mailto:mariam.deacy@nih.gov" target="_blank">mariam.deacy@nih.gov</a>.</p>
						</div>
					</div>
					<div class="form-group row">
						<label for="slack" class="col-sm-2 col-form-label">Slack Email</label>
						<div class="col-sm-10">
							<input name="slack" type="text" class="form-control" id="slack"	value="${n3c:registrationSlackIdValue()}">
							<p class="supplemental-question-info">We use Slack to communicate and invite all who onboard to join our <a href="https://join.slack.com/t/cd2h/signup" target="_blank">Slack org</a>.</p>
						</div>
					</div>
					<div class="form-group row">
						<label for="github" class="col-sm-2 col-form-label">GitHub ID</label>
						<div class="col-sm-10">
							<input name="github" type="text" class="form-control" id="github" value="${n3c:registrationGithubIdValue()}">
							<p class="supplemental-question-info">We use Github for issue tracking and management. You can create a free profile and generate a handle at <a href="http://github.com" target="_blank">GitHub.com</a> if you do not already have one.
							You will be able to view issues without a handle; however, you will not be able to log issues without one.</p>
						</div>
					</div>
					<div class="form-group row">
						<label for="twitter" class="col-sm-2 col-form-label">Twitter ID</label>
						<div class="col-sm-10">
							<input name="twitter" type="text" class="form-control"	id="twitter" value="${n3c:registrationTwitterIdValue()}">
						</div>
					</div>
		            <div class="form-group row">
		                <label for="assistant" class="col-sm-2 col-form-label">Assistant's Email</label>
		                <div class="col-sm-10">
		                    <input name="assistant" type="text" class="form-control" id="assistant" value="${n3c:registrationAssistantEmailValue()}">
		                    <p class="supplemental-question-info">If you have an assistant that you would like copied in correspondence about meeting schedules, please provide their contact email.</p>
		                </div>
		            </div>
					<p style="text-align:center; font-size:18px; font-weight:500;">Please select the workstream(s) in which you would like to	participate:</p>
		            <div  style="margin-bottom:65px;">
			            <n3c:foreachWorkstream var="x">
			                <n3c:workstream>
			                    <div class="form-check mb-4">
			                    	<c:set var='workstream' value="${n3c:workstreamLabelValue()}"/>
			                        <input type="checkbox" id="${n3c:workstreamLabelValue()}" name="${n3c:workstreamLabelValue()}" value="${n3c:workstreamLabelValue()}" class="form-check-input" <c:if test="${n3c:membershipExists(user_email,workstream)}">checked</c:if>>
			                        <label class="form-check-label" for="${n3c:workstreamLabelValue()}"><strong class="accent-text_2" style="font-size:16px;"><n3c:workstreamFullName/> </strong> - <span style="font-weight:300; font-size:16px"><n3c:workstreamDescription/></span></label>
			                    </div>
			                </n3c:workstream>
			            </n3c:foreachWorkstream>
		            </div>
				</div>

				<input type="hidden" name="official_first_name" value="${n3c:registrationOfficialFirstNameValue()}">
                <input type="hidden" name="official_last_name" value="${n3c:registrationOfficialLastNameValue()}">
                <input type="hidden" name="official_full_name" value="${n3c:registrationOfficialFullNameValue()}">
                <input type="hidden" name="official_institution" value="${n3c:registrationOfficialInstitutionValue()}">
            
            <div style="text-align:right;">
            	<button class="btn btn-n3c" type="submit" name="action" value="submit">Submit</button>
            </div>
    	</form>
        </n3c:registration>
	</div>
    <jsp:include page="footer.jsp" flush="true" />
<script src="<util:applicationRoot/>/abms_data.jsp"></script>
<script src="<util:applicationRoot/>/resources/autocomplete.js"></script>
<script>
autocomplete(document.getElementById("therapeutic"), countries);
</script>
	<script type="text/javascript">
		function enclaveFunction() {
			var x = document.getElementById("enclave-div");
			if (x.style.display === "none") {
				x.style.display = "block";
			} else {
				x.style.display = "none";
			}
		}

		function workstreamFunction() {
            var x = document.getElementById("workstream-div");
            if (x.style.display === "none") {
                x.style.display = "block";
            } else {
                x.style.display = "none";
            }
        }
		
		function orcidFunction() {
			var orcid_choices = document.getElementsByName("orcid_choice");
			for (var i = 0; i < orcid_choices.length; i++) {
				if (orcid_choices[i].checked)
		            document.getElementById("orcid").value = orcid_choices[i].value;
			}
        }
		
		function validateForm() {
			  var first_name = document.forms["registration"]["first_name"].value;
			  if (first_name == "") {
			    alert("First name is required");
			    return false;
			  }
              var last_name = document.forms["registration"]["last_name"].value;
              if (last_name == "") {
                alert("Last name is required");
                return false;
              }
              var institution = document.forms["registration"]["institution"].value;
              if (institution == "") {
                alert("Institution is required");
                return false;
              }
              var enclave = document.getElementById("enclave").checked;
              var orcid = document.forms["registration"]["orcid"].value;
              if (enclave == true && orcid.match(/^([0-9]{4}-){3}[0-9]{3}[0-9X]$/) == null) {
                alert("A valid ORCiD ID is required for Enclave access (0000-0000-0000-0000)");
                return false;
              }
		}
	</script>
</body>
</html>
