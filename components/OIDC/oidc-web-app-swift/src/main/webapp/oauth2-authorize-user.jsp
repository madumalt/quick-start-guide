<%@page import="org.apache.oltu.oauth2.client.request.OAuthClientRequest" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.util.SSOAgentConstants.SSOAgentConfig.OIDC" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.util.SSOAgentFilterUtils" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.SSOAgentConfig" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>

<%
    try {
        SSOAgentConfig ssoAgentConfig = SSOAgentFilterUtils.getSSOAgentConfig(application);
        
        String consumerKey = ssoAgentConfig.getOidc().getConsumerKey();
        String authzEndpoint = ssoAgentConfig.getOidc().getAuthzEndpoint();
        String authzGrantType = ssoAgentConfig.getOidc().getAuthzGrantType();
        String scope = ssoAgentConfig.getOidc().getScope();
        String callBackUrl = ssoAgentConfig.getOidc().getCallBackUrl();
        String OIDC_LOGOUT_ENDPOINT = ssoAgentConfig.getOidc().getOIDCLogoutEndpoint();
        String sessionIFrameEndpoint = ssoAgentConfig.getOidc().getOIDCLogoutEndpoint();
        
        session.setAttribute(OIDC.OAUTH2_GRANT_TYPE, authzGrantType);
        session.setAttribute(OIDC.CONSUMER_KEY, consumerKey);
        session.setAttribute(OIDC.SCOPE, scope);
        session.setAttribute(OIDC.CALL_BACK_URL, callBackUrl);
        session.setAttribute(OIDC.OAUTH2_AUTHZ_ENDPOINT, authzEndpoint);
        session.setAttribute(OIDC.OIDC_LOGOUT_ENDPOINT, OIDC_LOGOUT_ENDPOINT);
        session.setAttribute(OIDC.OIDC_SESSION_IFRAME_ENDPOINT, sessionIFrameEndpoint);
        
        OAuthClientRequest.AuthenticationRequestBuilder oAuthAuthenticationRequestBuilder =
                new OAuthClientRequest.AuthenticationRequestBuilder(authzEndpoint);
        oAuthAuthenticationRequestBuilder
                .setClientId(consumerKey)
                .setRedirectURI((String) session.getAttribute(OIDC.CALL_BACK_URL))
                .setResponseType(authzGrantType)
                .setScope(scope);
        
        OAuthClientRequest authzRequest = oAuthAuthenticationRequestBuilder.buildQueryMessage();
        response.sendRedirect(authzRequest.getLocationUri());
        return;
        
    } catch (Exception e) {
%>

<script type="text/javascript">
    window.location = "index.jsp";
</script>

<%
    }
%>



    