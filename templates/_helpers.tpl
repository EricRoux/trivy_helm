{{- define "trivy.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "trivy" .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "trivy.redis" -}}
  {{- printf "%s-redis" (include "trivy.fullname" .) -}}
{{- end -}}

{{- define "trivy.labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
app: "{{ template "trivy.name" . }}"
{{- end -}}


{{- define "trivy.name" -}}
  {{- printf "%s" (include "trivy.fullname" .) -}}
{{- end -}}

{{- define "trivy.redis" -}}
  {{- printf "%s-redis" (include "trivy.fullname" .) -}}
{{- end -}}

{{- define "trivy.redis.addr" -}}
  {{- with .Values.redis }}
    {{- printf "%s:6379" (include "trivy.redis" $ ) }}
  {{- end }}
{{- end -}}

# "redis://trivy-redis:6379/redis"
/*scheme://[redis:password@]host:port[/master_set]*/
{{- define "trivy.redis.url" -}}
  {{- with .Values.redis }}
    {{- printf "redis://%s%s" (include "trivy.redis.addr" $) "/redis" -}}
  {{- end }}
{{- end -}}

# redis://trivy-redis:6379/redis/5?idle_timeout_seconds=30
/*scheme://[redis:password@]addr/5?idle_timeout_seconds=30*/
{{- define "trivy.redis.urlForTrivy" -}}
  {{- printf "%s/5?idle_timeout_seconds=30" (include "trivy.redis.url" $) -}}
{{- end -}}


{{/* matchLabels */}}
{{- define "trivy.matchLabels" -}}
release: {{ .Release.Name }}
app: "{{ template "trivy.name" . }}"
{{- end -}}

{{/* trivy component container port */}}
{{- define "harbor.trivy.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}
