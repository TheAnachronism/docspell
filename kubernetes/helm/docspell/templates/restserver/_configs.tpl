{{/*App ID*/}}
{{- define "docspell.server.config.appId" -}}
{{- $appId := .Values.docspell.server.appId | default (printf "%s-restserver" (include "docspell.fullname" .)) -}}
{{- print $appId -}}
{{- end -}}

{{/*Logging Config*/}}
{{- define "docspell.server.config.logging" -}}
{{- $envPrefix := "DOCSPELL_SERVER_LOGGING" -}}
{{ $envPrefix }}_FORMAT: {{ .Values.docspell.server.logging.format }}
{{ $envPrefix }}_MINIMUM__LEVEL: {{ .Values.docspell.server.logging.minimumLevel }}
{{- end -}}

{{/*Bind Config*/}}
{{- define "docspell.server.config.bind" -}}
{{- if not (eq .Values.restserver.service.port .Values.docspell.server.bind.port) -}}
{{- fail "The restserver and it's service don't have to use the same port, no connection will be possible." -}}
{{- end -}}
{{- $envPrefix := "DOCSPELL_SERVER_BIND" -}}
{{ $envPrefix }}_ADDRESS: {{ .Values.docspell.server.bind.address | quote }}
{{ $envPrefix }}_PORT: {{ .Values.docspell.server.bind.port | quote }}
{{- end -}}

{{/*Auth Config*/}}
{{- define "docspell.server.config.auth" -}}
{{- $envPrefix := "DOCSPELL_SERVER_AUTH" -}}
{{ $envPrefix }}_SESSION__VALID: {{ .Values.docspell.server.auth.sessionValid | quote }}
{{ $envPrefix }}_REMEMBER__ME_ENABLED: {{ .Values.docspell.server.auth.rememberMe.enabled | quote }}
{{ $envPrefix }}_REMEMBER__ME_VALID: {{ .Values.docspell.server.auth.rememberMe.valid | quote }}
{{ $envPrefix }}_ON__ACCOUNT__SOURCE__CONFLICT: {{ .Values.docspell.server.auth.onAccountSourceConflict }}
{{- end -}}

{{/*Auth Secrets*/}}
{{- define "docspell.server.secrets.auth" -}}
{{- with .Values.docspell.server.auth.serverSecret }}
DOCSPELL_SERVER_AUTH_SERVER__SECRET: {{ . }}
{{- end }}
{{- end -}}

{{/*Download Config*/}}
{{- define "docspell.server.config.donwload" -}}
{{- $envPrefix := "DOCSPELL_SERVER_DOWNLOAD__ALL" -}}
{{ $envPrefix }}_MAX__FILES: {{ .Values.docspell.server.donwloadAll.maxFiles | quote }}
{{ $envPrefix }}_MAX__SIZE: {{ .Values.docspell.server.donwloadAll.maxSize }}
{{- end -}}

{{/*OpenID Config*/}}
{{- define "docspell.server.config.openid" -}}
{{- $envPrefix := "DOCSPELL_SERVER_OPENID" -}}
{{- range $index, $entry := .Values.docspell.server.openid -}}
{{- if $entry.enabled -}}
{{ $envPrefix }}_{{ $index }}_DISPLAY: {{ $entry.display }}
{{ $envPrefix }}_{{ $index }}_ENABLED: {{ $entry.enabled | quote }}
{{ $envPrefix }}_{{ $index }}_COLLECTIVE__KEY: {{ $entry.collectiveKey }}
{{ $envPrefix }}_{{ $index }}_USER__KEY: {{ $entry.userKey }}
{{- $envPrefix = printf "%s_%s_PROVIDER" $envPrefix ($index | toString) }}
{{ $envPrefix }}_PROVIDER__ID: {{ $entry.provider.providerId }}
{{ $envPrefix }}_SCOPE: {{ $entry.provider.scope }}
{{ $envPrefix }}_AUTHORIZE__URL: {{ $entry.provider.authorizeUrl }}
{{ $envPrefix }}_TOKEN__URL: {{ $entry.provider.tokenUrl }}
{{- with $entry.provider.userUrl }}
{{ $envPrefix }}_USER__URL: {{ . }}
{{- end }}
{{ $envPrefix }}_LOGOUT__URL: {{ $entry.provider.logoutUrl }}
{{ $envPrefix }}_SIG__ALGO: {{ $entry.provider.sigAlgo }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*OpenID Secrets*/}}
{{- define "docspell.server.secrets.openid" -}}
{{- $envPrefix := "DOCSPELL_SERVER_OPENID" -}}
{{- range $index, $entry := .Values.docspell.server.openid -}}
{{- if $entry.enabled -}}
{{- $envPrefix = printf "%s_%s_PROVIDER" $envPrefix ($index | toString) }}
{{ $envPrefix }}_CLIENT__ID: {{ $entry.provider.clientId }}
{{ $envPrefix }}_CLIENT__SECRET: {{ $entry.provider.clientSecret }}
{{ $envPrefix }}_SIGN__KEY: {{ $entry.provider.signKey }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*Database Schema Settings*/}}
{{- define "docspell.server.config.databaseSchema" -}}
{{- $envPrefix := "DOCSPELL_SERVER_BACKEND_DATABASE__SCHEMA" -}}
{{ $envPrefix }}_RUN__MAIN__MIGRATIONS: {{ .Values.docspell.server.backend.databaseSchema.runMainMigrations | quote }}
{{ $envPrefix }}_RUN__FIXUP__MIGRATIONS: {{ .Values.docspell.server.backend.databaseSchema.runFixupMigrations | quote }}
{{ $envPrefix }}_REPAIR__SCHEMA: {{ .Values.docspell.server.backend.databaseSchema.repairSchema | quote }}
{{- end -}}

{{/*Integration Endpoint Settings*/}}
{{- define "docspell.server.config.integrationEndpoint" -}}
{{- $envPrefix := "DOCSPELL_SERVER_INTEGRATION__ENDPOINT" -}}
{{ $envPrefix }}_ENABLED: {{ .Values.docspell.server.integrationEndpoint.enabled | quote }}
{{ $envPrefix }}_PRIORITY: {{ .Values.docspell.server.integrationEndpoint.priority }}
{{ $envPrefix }}_SOURCE__NAME: {{ .Values.docspell.server.integrationEndpoint.sourceName }}
{{- if .Values.docspell.server.integrationEndpoint.allowedIps.enabed }}
{{ $envPrefix }}_ALLOWED__IPS_ENABLED: {{ .Values.docspell.server.integrationEndpoint.allowedIps.enabed }}
{{- range $index, $ip := .Values.docspell.server.integrationEndpoint.allowedIps.ips }}
{{ $envPrefix }}_ALLOWED__IPS_IPS_{{ $index}}: {{ $ip }}
{{- end }}
{{- end }}
{{- if .Values.docspell.server.integrationEndpoint.httpBasic.enabled | quote }}
{{ $envPrefix }}_HTTP__BASIC_ENABLED: {{ .Values.docspell.server.integrationEndpoint.httpBasic.enabled | quote }}
{{- end }}
{{- if .Values.docspell.server.integrationEndpoint.httpHeader.enabled | quote }}
{{ $envPrefix }}_HTTP__HEADER_ENABLED: {{ .Values.docspell.server.integrationEndpoint.httpHeader.enabled | quote }}
{{- end }}
{{- end }}

{{/*Integration Endpoint Secrets*/}}
{{- define "docspell.server.secrets.integrationEndpoint" -}}
{{- if .Values.docspell.server.integrationEndpoint.httpBasic.enabled | quote -}}
{{- $envPrefix := "DOCSPELL_SERVER_INTEGRATION__ENDPOINT__HTTP__BASIC" -}}
{{ $envPrefix}}_REALM: {{ .Values.docspell.server.integrationEndpoint.httpBasic.realm }}
{{ $envPrefix}}_USER: {{ .Values.docspell.server.integrationEndpoint.httpBasic.user }}
{{ $envPrefix}}_PASSWORD: {{ .Values.docspell.server.integrationEndpoint.httpBasic.password }}
{{- end }}
{{- if .Values.docspell.server.integrationEndpoint.httpHeader.enabled | quote -}}
{{ $envPrefix := "DOCSPELL_SERVER_INTEGRATION__ENDPOINT__HTTP__HEADER" }}
{{ $envPrefix }}_HEADER__NAME: {{ .Values.docspell.server.integrationEndpoint.httpHeader.headerName }}
{{ $envPrefix }}_HEADER__VALUE: {{ .Values.docspell.server.integrationEndpoint.httpHeader.headerValue }}
{{- end }}
{{- end -}}

{{/*Admin Endpoint Secrets*/}}
{{- define "docspell.server.secrets.adminEndpoint" -}}
{{- with .Values.docspell.server.adminEndpoint.secret }}
DOCSPELL_SERVER_ADMIN__ENDPOINT_SECRET: {{ . }}
{{- end }}
{{- end -}}

{{/*Signup Settings*/}}
{{- define "docspell.server.config.signup" -}}
{{- $envPrefix := "DOCSPELL_SERVER_BACKEND_SIGNUP" -}}
{{ $envPrefix }}_MODE: {{ .Values.docspell.server.backend.signup.mode }}
{{- if eq .Values.docspell.server.backend.signup.mode "invite" }}
{{ $envPrefix }}_INVITE__TIME: {{ .Values.docspell.server.backend.signup.inviteTime }}
{{- end -}}
{{- end -}}

{{/*Signup Secrets*/}}
{{- define "docspell.server.secrets.signup" -}}
{{- if eq .Values.docspell.server.backend.signup.mode "invite" }}
DOCSPELL_SERVER_BACKEND_SIGNUP_NEW__INVITE__PASSWORD: {{ .Values.docspell.server.backend.signup.newInvitePassword }}
{{- end -}}
{{- end -}}