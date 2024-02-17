{{/*Common labels*/}}
{{- define "joex.labels" -}}
helm.sh/chart: {{ include "docspell.chart" . }}
app: {{ include "docspell.name" . }}-joex
{{ include "joex.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.joex.image.tag | default .Chart.AppVersion | quote }}
version: {{ .Values.joex.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*Selector labels*/}}
{{- define "joex.selectorLabels" -}}
app.kubernetes.io/name: {{ include "docspell.name" . }}-joex
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*Create joex image name and tag used by the deployment*/}}
{{- define "joex.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.joex.image.registry -}}
{{- $repository := .Values.joex.image.repository -}}
{{- $separator := ":" -}}
{{- $tag := .Values.joex.image.tag | default .Chart.AppVersion -}}
{{- if $registry -}}
    {{- printf "%s/%s%s%s" $registry $repository $separator $tag -}}
{{- else -}}
    {{- printf "%s%s%s" $repository $separator $tag -}}
{{- end -}}
{{- end -}}

