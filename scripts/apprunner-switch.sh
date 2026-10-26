#!/bin/bash
# Pause/resume/status switch for all 6 HRB platform App Runner services.
# Pausing stops compute billing (the service's config/image/data are untouched -
# resuming brings the exact same deployment back, no rebuild). AWS docs confirm
# a paused service is not billed for compute while paused.
#
# Usage:
#   ./apprunner-switch.sh pause    - pause every RUNNING service
#   ./apprunner-switch.sh resume   - resume every PAUSED service
#   ./apprunner-switch.sh status   - just report current status of all 6

set -uo pipefail

REGION="us-east-1"

SERVICES=(
  "hrb-chatbot"
  "hrb-api-gateway"
  "hrb-lms-mcp"
  "rag-ingestion-service"
  "rag-retrieval-service"
  "hrb-platform-components"
)

ACTION="${1:-status}"

get_arn() {
  aws apprunner list-services --region "$REGION" \
    --query "ServiceSummaryList[?ServiceName=='$1'].ServiceArn" --output text
}

get_status() {
  aws apprunner describe-service --service-arn "$1" --region "$REGION" \
    --query "Service.Status" --output text
}

case "$ACTION" in
  status)
    printf "%-26s %s\n" "SERVICE" "STATUS"
    for name in "${SERVICES[@]}"; do
      arn=$(get_arn "$name")
      if [ -z "$arn" ]; then
        printf "%-26s %s\n" "$name" "NOT FOUND"
        continue
      fi
      status=$(get_status "$arn")
      printf "%-26s %s\n" "$name" "$status"
    done
    ;;

  pause)
    for name in "${SERVICES[@]}"; do
      arn=$(get_arn "$name")
      if [ -z "$arn" ]; then
        echo "SKIP     $name - not found"
        continue
      fi
      status=$(get_status "$arn")
      if [ "$status" = "PAUSED" ]; then
        echo "SKIP     $name - already paused"
      elif [ "$status" = "RUNNING" ]; then
        aws apprunner pause-service --service-arn "$arn" --region "$REGION" >/dev/null 2>&1
        echo "PAUSING  $name"
      else
        echo "SKIP     $name - status is $status, not RUNNING"
      fi
    done
    echo ""
    echo "Pause requests sent - each takes ~30-60s to actually reach PAUSED."
    echo "Check with: ./apprunner-switch.sh status"
    ;;

  resume)
    for name in "${SERVICES[@]}"; do
      arn=$(get_arn "$name")
      if [ -z "$arn" ]; then
        echo "SKIP     $name - not found"
        continue
      fi
      status=$(get_status "$arn")
      if [ "$status" = "RUNNING" ]; then
        echo "SKIP     $name - already running"
      elif [ "$status" = "PAUSED" ]; then
        aws apprunner resume-service --service-arn "$arn" --region "$REGION" >/dev/null 2>&1
        echo "RESUMING $name"
      else
        echo "SKIP     $name - status is $status, not PAUSED"
      fi
    done
    echo ""
    echo "Resume requests sent - each takes 1-2 min to actually reach RUNNING."
    echo "Check with: ./apprunner-switch.sh status"
    ;;

  *)
    echo "Usage: $0 {pause|resume|status}"
    exit 1
    ;;
esac
