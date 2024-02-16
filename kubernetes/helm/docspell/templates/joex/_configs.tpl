{{/*App ID*/}}
{{- define "docspell.joex.config.appId" -}}
{{- $appId := .Values.docspell.joex.appId | default (printf "%s-joex" (include "docspell.fullname" .)) -}}
{{- print $appId -}}
{{- end -}}

{{/*
Base URL
*/}}
{{- define "docspell.joex.config.baseUrl" -}}
{{- $service := printf "%s-joex" (include "docspell.fullname" .) -}}
{{- $port := .Values.joex.service.port | toString -}}
{{- printf "http://%s:%s" $service $port -}}
{{- end -}}

{{/*Bind Config*/}}
{{- define "docspell.joex.config.bind" -}}
{{- if not (eq .Values.joex.service.port .Values.docspell.joex.bind.port) -}}
{{- fail "Joex and it's service don't have to use the same port, no connection will be possible." -}}
{{- end -}}
{{- $envPrefix := "DOCSPELL_JOEX_BIND" -}}
{{ $envPrefix }}_ADDRESS: {{ .Values.docspell.joex.bind.address | quote }}
{{ $envPrefix }}_PORT: {{ .Values.docspell.joex.bind.port | quote }}
{{- end -}}

{{/*Logging Config*/}}
{{- define "docspell.joex.config.logging" -}}
{{- $envPrefix := "DOCSPELL_JOEX_LOGGING" -}}
{{ $envPrefix }}_FORMAT: {{ .Values.docspell.joex.logging.format }}
{{ $envPrefix }}_MINIMUM__LEVEL: {{ .Values.docspell.joex.logging.minimumLevel }}
{{- end -}}

{{/*JDBC Connection*/}}
{{- define "docspell.joex.config.JDBC" -}}
{{- $envPrefix := "DOCSPELL_JOEX_JDBC" -}}
{{ $envPrefix }}_USER: {{ .Values.postgresql.global.postgresql.auth.username }}
{{ $envPrefix }}_PASSWORD: {{ .Values.postgresql.global.postgresql.auth.password }}
{{ $envPrefix }}_URL: {{ include "postgresql.jdbcUrl" . }}
{{- end -}}

{{/*Database Schema Settings*/}}
{{- define "docspell.joex.config.databaseSchema" -}}
{{- $envPrefix := "DOCSPELL_JOEX_DATABASE__SCHEMA" -}}
{{ $envPrefix }}_RUN__MAIN__MIGRATIONS: {{ .Values.docspell.joex.databaseSchema.runMainMigrations | quote }}
{{ $envPrefix }}_RUN__FIXUP__MIGRATIONS: {{ .Values.docspell.joex.databaseSchema.runFixupMigrations | quote }}
{{ $envPrefix }}_REPAIR__SCHEMA: {{ .Values.docspell.joex.databaseSchema.repairSchema | quote }}
{{- end -}}

{{/*Scheduler Settings*/}}
{{- define "docspell.joex.config.scheduler" -}}
{{- $envPrefix := "DOCSPELL_JOEX_SCHEDULER" -}}
{{ $envPrefix }}_NAME: {{ default (include "docspell.joex.config.appId" .) .Values.docspell.joex.scheduler.name }}
{{ $envPrefix }}_POOL__SIZE: {{ .Values.docspell.joex.scheduler.poolSize | quote }}
{{ $envPrefix }}_COUNTING__SCHEME: {{ .Values.docspell.joex.scheduler.countingScheme | quote }}
{{ $envPrefix }}_RETRIES: {{ .Values.docspell.joex.scheduler.retries | quote }}
{{ $envPrefix }}_RETRY__DELAY: {{ .Values.docspell.joex.scheduler.retryDelay | quote }}
{{ $envPrefix }}_LOG__BUFFER__SIZE: {{ .Values.docspell.joex.scheduler.logBufferSize | quote }}
{{ $envPrefix }}_WAKEUP__PERIOD: {{ .Values.docspell.joex.scheduler.wakeupPeriod | quote }}
{{- end -}}

{{/*PeriodScheduler Settings*/}}
{{- define "docspell.joex.config.periodicScheduler" -}}
{{- $envPrefix := "DOCSPELL_JOEX_PERIODIC__SCHEDULER" -}}
{{ $envPrefix }}_NAME: {{ default (include "docspell.joex.config.appId" .) .Values.docspell.joex.periodicScheduler.name }}
{{ $envPrefix }}_WAKEUP__PERIOD: {{ .Values.docspell.joex.periodicScheduler.wakeupPeriod | quote }}
{{- end -}}

{{/*User Tasks Settings*/}}
{{- define "docspell.joex.config.userTasks" -}}
{{- $envPrefix := "DOCSPELL_JOEX_USER__TASKS_SCAN__MAILBOX" -}}
{{ $envPrefix }}_MAX__FOLDERS: {{ .Values.docspell.joex.userTasks.scanMailbox.maxFolders | quote }}
{{ $envPrefix }}_MAIL__CHUNK__SIZE: {{ .Values.docspell.joex.userTasks.scanMailbox.mailChunkSize | quote }}
{{ $envPrefix }}_MAX__MAILS: {{ .Values.docspell.joex.userTasks.scanMailbox.maxMails | quote }}
{{- end -}}

{{/*House Keeping Settings*/}}
{{- define "docspell.joex.config.houseKeeping" -}}
{{- $envPrefix := "DOCSPELL_JOEX_HOUSE__KEEPING" -}}
{{ $envPrefix }}_SCHEDULE: {{ .Values.docspell.joex.houseKeeping.schedule | quote }}
{{ $envPrefix }}_CLEANUP__INVITES_ENABLED: {{ .Values.docspell.joex.houseKeeping.cleanupInvites.enabled | quote }}
{{ $envPrefix }}_CLEANUP__INVITES_OLDER__THAN: {{ .Values.docspell.joex.houseKeeping.cleanupInvites.olderThan | quote }}
{{ $envPrefix }}_CLEANUP__REMEMBER__ME_ENABLED: {{ .Values.docspell.joex.houseKeeping.cleanupRememberMe.enabled | quote }}
{{ $envPrefix }}_CLEANUP__REMEMBER__ME_OLDER__THAN: {{ .Values.docspell.joex.houseKeeping.cleanupRememberMe.olderThan | quote }}
{{ $envPrefix }}_CLEANUP__JOBS_ENABLED: {{ .Values.docspell.joex.houseKeeping.cleanupJobs.enabled | quote }}
{{ $envPrefix }}_CLEANUP__JOBS_OLDER__THAN: {{ .Values.docspell.joex.houseKeeping.cleanupJobs.olderThan | quote }}
{{ $envPrefix }}_CLEANUP__JOBS_DELETE__BATCH: {{ .Values.docspell.joex.houseKeeping.cleanupJobs.deleteBatch | quote }}
{{ $envPrefix }}_CLEANUP__DOWNLOADS_ENABLED: {{ .Values.docspell.joex.houseKeeping.cleanupDownloads.enabled | quote }}
{{ $envPrefix }}_CLEANUP__DOWNLOADS_OLDER__THAN: {{ .Values.docspell.joex.houseKeeping.cleanupDownloads.olderThan | quote }}
{{ $envPrefix }}_CLEANUP__NODES_ENABLED: {{ .Values.docspell.joex.houseKeeping.cleanupNodes.enabled | quote }}
{{ $envPrefix }}_CLEANUP__NODES_MIN__NOT__FOUND: {{ .Values.docspell.joex.houseKeeping.cleanupNodes.minNotFound |quote }}
{{ $envPrefix }}_INTEGRITY__CHECK_ENABLED: {{ .Values.docspell.joex.houseKeeping.integrityCheck.enabled | quote }}
{{- end -}}

{{/*Update Check Settings*/}}
{{- define "docspell.joex.config.updateCheck" -}}
{{- if and .Values.docspell.joex.updateCheck.enabled (not .Values.docspell.joex.updateCheck.recipients) -}}
{{- fail "Update check recipients have to be set when enabling update check" -}}
{{- end -}}
{{- $envPrefix := "DOCSPELL_JOEX_UPDATE__CHECK" -}}
{{ $envPrefix }}_ENABLED: {{ .Values.docspell.joex.updateCheck.enabled | quote }}
{{ $envPrefix }}_TEST__RUN: {{ .Values.docspell.joex.updateCheck.testRun | quote }}
{{ $envPrefix }}_SCHEDULE: {{ .Values.docspell.joex.updateCheck.schedule | quote }}
{{- if .Values.docspell.joex.updateCheck.senderAccount }}
{{ $envPrefix }}_SENDER__ACOUNT: {{ .Values.docspell.joex.updateCheck.senderAccount }}
{{ $envPrefix }}_SMTP__ID: {{ .Values.docspell.joex.updateCheck.smtpId }}
{{- end }}
{{- range $index, $recipient := .Values.docspell.joex.updateCheck.recipients }}
{{ $envPrefix }}_RECIPIENTS_{{ $index }}: {{ $recipient }}
{{- end }}
{{ $envPrefix }}_SUBJECT: {{ .Values.docspell.joex.updateCheck.subject }}
{{ $envPrefix }}_BODY: | {{ .Values.docspell.joex.updateCheck.body | nindent 4 }}
{{- end -}}

{{/*Convert Settings*/}}
{{- define "docspell.joex.config.convert" -}}
{{- $envPrefix := "DOCSPELL_JOEX_CONVERT" -}}
{{ $envPrefix }}_HTML__CONVERTER: {{ .Values.docspell.joex.convert.htmlConverter }}
{{- end -}}

{{/*Full Text Search Settings*/}}
{{- define "docspell.joex.config.fullTextSearch" -}}
{{- if .Values.docspell.fullTextSearch.enabled -}}
DOCSPELL_JOEX_FULL__TEXT__SEARCH_MIGRATION_INDEX__ALL__CHUNK: {{ .Values.docspell.joex.fullTextSearch.migration.indexAllChink | quote }}
{{- end -}}
{{- end -}}