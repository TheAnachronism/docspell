{{/*
Common labels
*/}}
{{- define "solr.labels" -}}
helm.sh/chart: {{ include "docspell.chart" . }}
app: {{ include "docspell.name" . }}-solr
{{ include "solr.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.solr.image.tag | quote }}
version: {{ .Values.solr.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "solr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "docspell.name" . }}-solr
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create solr image name and tag used by the deployment
*/}}
{{- define "solr.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.solr.image.registry -}}
{{- $repository := .Values.solr.image.repository -}}
{{- $separator := ":" -}}
{{- $tag := .Values.solr.image.tag | default .Chart.AppVersion -}}
{{- if $registry -}}
    {{- printf "%s/%s%s%s" $registry $repository $separator $tag -}}
{{- else -}}
    {{- printf "%s%s%s" $repository $separator $tag -}}
{{- end -}}
{{- end -}}

{{/*
Connection URL
*/}}
{{- define "solr.url" -}}
{{- $port := .Values.solr.service.port | toString -}}
{{- $service := printf "%s-solr" (include "docspell.fullname" .) -}}
{{- printf "http://%s:%s/solr/docspell" $service $port -}}
{{- end }}

{{/*
Storage Class
*/}}
{{- define "solr.persistence.storageClass" -}}
{{- $storageClass := .Values.solr.persistence.storageClass | default .Values.global.storageClass -}}
{{- if $storageClass -}}
storageClassName: {{ $storageClass | quote }}
{{- end -}}
{{- end -}}