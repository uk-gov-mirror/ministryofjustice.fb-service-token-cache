#!/bin/sh

FB_APPLICATION='fb-service-token-cache' node_modules/\@ministryofjustice/fb-deploy-utils/bin/restart_platform_pods.sh $@
