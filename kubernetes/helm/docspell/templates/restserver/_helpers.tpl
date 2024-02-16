{{/*
Common labels
*/}}
{{- define "restserver.labels" -}}
helm.sh/chart: {{ include "docspell.chart" . }}
app: {{ include "docspell.name" . }}-restserver
{{ include "restserver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.restserver.image.tag | default .Chart.AppVersion | quote }}
version: {{ .Values.restserver.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "restserver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "docspell.name" . }}-restserver
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create restserver image name and tag used by the deployment
*/}}
{{- define "restserver.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.restserver.image.registry -}}
{{- $repository := .Values.restserver.image.repository -}}
{{- $separator := ":" -}}
{{- $tag := .Values.restserver.image.tag | default .Chart.AppVersion -}}
{{- if $registry -}}
    {{- printf "%s/%s%s%s" $registry $repository $separator $tag -}}
{{- else -}}
    {{- printf "%s%s%s" $repository $separator $tag -}}
{{- end -}}
{{- end -}}
