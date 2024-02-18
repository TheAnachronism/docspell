{{- define "docspell.server.secrets.existingSecrets" -}}
{{/*Server Secret*/}}
{{- if .Values.docspell.server.auth.serverSecret -}}
{{- if and .Values.docspell.server.auth.serverSecret.existingSecret (not .Values.docspell.server.auth.serverSecret.value) -}}
- name: DOCSPELL_SERVER_AUTH_SERVER__SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Values.docspell.server.auth.serverSecret.existingSecret.name }}
      key: {{ .Values.docspell.server.auth.serverSecret.existingSecret.key }}
{{- end -}}
{{- end }}
{{/*OIDC Secrets*/}}
{{- range $index, $entry := .Values.docspell.server.openid -}}
{{- if and $entry.enabled $entry.provider.existingSecret -}}
{{- $envPrefix := printf "%s_%s_PROVIDER" "DOCSPELL_SERVER_OPENID" ($index | toString) -}}
- name: {{ $envPrefix }}_CLIENT__ID
  valueFrom:
    secretKeyRef:
      name: {{ $entry.provider.existingSecret.name }}
      key: {{ $entry.provider.existingSecret.clientIdKey }}
- name: {{ $envPrefix }}_CLIENT__SECRET
  valueFrom:
    secretKeyRef:
      name: {{ $entry.provider.existingSecret.name }}
      key: {{ $entry.provider.existingSecret.clientSecretKey }}
- name: {{ $envPrefix }}_SIGN__KEY
{{- if $entry.provider.existingSecret.signKeyKey -}}
  valueFrom:
    secretKeyRef:
      name: {{ $entry.provider.existingSecret.name }}
      key: {{ $entry.provider.existingSecret.signKeyKey }}
{{- else }}
  value: ""
{{- end -}}
{{- end -}}
{{- end -}}
{{/*Integration Endpoint Http Basic Auth*/}}
{{- if .Values.docspell.server.integrationEndpoint.httpBasic.existingSecret }}
- name: DOCSPELL_SERVER_INTEGRATION__ENDPOINT_HTTP__BASIC_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.docspell.server.integrationEndpoint.httpBasic.existingSecret.name }}
      key: {{ .Values.docspell.server.integrationEndpoint.httpBasic.existingSecret.usernameKey }}
- name: DOCSPELL_SERVER_INTEGRATION__ENDPOINT_HTTP__BASIC_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.docspell.server.integrationEndpoint.httpBasic.existingSecret.name }}
      key: {{ .Values.docspell.server.integrationEndpoint.httpBasic.existingSecret.passwordKey }}
{{- end }}
{{/*Integration Endpoint Http Header Auth*/}}
{{- if and .Values.docspell.server.integrationEndpoint.enabled .Values.docspell.server.integrationEndpoint.httpHeader.enabled -}}
{{- if .Values.docspell.server.integrationEndpoint.httpHeader.headerValue.existingSecret }}
- name: DOCSPELL_SERVER_INTEGRATION__ENDPOINT_HTTP__HEADER_HEADER__VALUE
  valueFrom:
    secretKeyRef:
      name: {{ .Values.docspell.server.integrationEndpoint.httpHeader.headerValue.existingSecret.name }}
      key: {{ .Values.docspell.server.integrationEndpoint.httpHeader.headerValue.existingSecret.key }}
{{- end -}}
{{- end }}
{{/*Admin Endpoint Secret*/}}
{{- with .Values.docspell.server.adminEndpoint.existingSecret }}
- name: DOCSPELL_SERVER_ADMIN__ENDPOINT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .name }}
      key: {{ .key }}
{{- end }}
{{/*Sign Up Invitation Generation Password*/}}
{{- if eq .Values.docspell.server.backend.signup.mode "invite" -}}
{{- with .Values.docspell.server.backend.signup.newInvitePassword.existingSecret }}
- name: DOCSPELL_SERVER_BACKEND_SIGNUP_NEW__INVITE__PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .name }}
      key: {{ .key }}
{{- end -}}
{{- end }}
{{/*PostgreSQL Password*/}}
{{- if .Values.postgresql.global.postgresql.auth.existingSecret -}}
- name: DOCSPELL_SERVER_BACKEND_JDBC_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.postgresql.global.postgresql.auth.existingSecret }}
      key: {{ .Values.postgresql.global.postgresql.auth.secretKeys.userPasswordKey | default "password" }}
{{- end -}}
{{- end -}}