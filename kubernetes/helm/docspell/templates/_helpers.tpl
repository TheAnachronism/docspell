{{/*Expand the name of the chart.*/}}
{{- define "docspell.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "docspell.fullname" -}}
{{- $name := .Chart.Name }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*Create chart name and version as used by the chart label.*/}}
{{- define "docspell.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Docker Image Registry Secret Names evaluating values as templates*/}}
{{- define "docspell.images.pullSecrets" -}}
{{- $pullSecrets := .Values.global.imagePullSecrets -}}
{{- range .Values.global.imagePullSecrets -}}
    {{- $pullSecrets = append $pullSecrets (dict "name" .) -}}
{{- end -}}
{{- if (not (empty $pullSecrets)) -}}
imagePullSecrets:
{{ toYaml $pullSecrets }}
{{- end -}}
{{- end -}}

{{/*Common labels*/}}
{{- define "docspell.labels" -}}
helm.sh/chart: {{ include "docspell.chart" . }}
{{ include "docspell.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*Selector labels*/}}
{{- define "docspell.selectorLabels" -}}
app.kubernetes.io/name: {{ include "docspell.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*Create the name of the service account to use*/}}
{{- define "docspell.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "docspell.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}