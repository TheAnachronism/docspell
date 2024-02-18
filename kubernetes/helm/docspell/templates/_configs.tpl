{{/*Postgres Access*/}}
{{- define "postgresql.jdbcUrl" -}}
{{- if (index .Values "postgresql").enabled -}}
{{- $port := .Values.postgresql.global.postgresql.service.postgresql | toString -}}
{{- $database := .Values.postgresql.global.postgresql.auth.database -}}
{{- printf "jdbc:postgresql://%s-postgresql:%s/%s" .Release.Name $port $database -}}
{{- end -}}
{{- end -}}

{{/*JDBC Connection*/}}
{{- define "docspell.secrets.JDBC" -}}
{{- if .context.Values.postgresql.enabled -}}
{{- $envPrefix := "DOCSPELL_SERVER_BACKEND_JDBC" -}}
{{- if eq .type "joex" -}}
{{- $envPrefix = "DOCSPELL_JOEX_JDBC" -}}
{{- end }}
{{ $envPrefix }}_USER: {{ .context.Values.postgresql.global.postgresql.auth.username }}
{{- if not .context.Values.postgresql.global.postgresql.auth.existingSecret }}
{{ $envPrefix }}_PASSWORD: {{ .context.Values.postgresql.global.postgresql.auth.password }}
{{- end }}
{{ $envPrefix }}_URL: {{ include "postgresql.jdbcUrl" .context }}
{{- end -}}
{{- end -}}

{{/*Full Text Search ettings*/}}
{{- define "docspell.config.fullTextSearch" -}}
{{- if .context.Values.docspell.fullTextSearch.enabled -}}
{{- $envPrefix := "DOCSPELL_SERVER_FULL__TEXT__SEARCH" -}}
{{- if eq .type "joex" -}}
{{- $envPrefix = "DOCSPELL_JOEX_FULL__TEXT__SEARCH" -}}
{{- end -}}
{{ printf "%s_ENABLED: %s" $envPrefix ( .context.Values.docspell.fullTextSearch.enabled | quote) }}
{{ printf "%s_SOLR_URL: http://%s-solr:%s/solr/docspell" $envPrefix (include "docspell.fullname" .context) ( .context.Values.solr.service.port | toString )}}
{{ printf "%s_SOLR_COMMIT__WITHIN: %s" $envPrefix ( .context.Values.docspell.fullTextSearch.solr.commitWithin | quote) }}
{{ printf "%s_SOLR_LOG__VERBOSE: %s" $envPrefix ( .context.Values.docspell.fullTextSearch.solr.logVerbose | quote ) }}
{{ printf "%s_SOLR_DEF__TYPE: %s" $envPrefix ( .context.Values.docspell.fullTextSearch.solr.defType | quote) }}
{{ printf "%s_SOLR_Q_OP: %s" $envPrefix ( .context.Values.docspell.fullTextSearch.solr.qOp | quote) }}
{{- end }}
{{- end }}