# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "iam_resources" {
  description = "Provisioned identity resources"
  value = {
    compartments   = length(module.oci_lz_compartments) > 0 ? module.oci_lz_compartments[0].compartments : {},
    groups         = length(module.oci_lz_groups) > 0 ? module.oci_lz_groups[0].groups : {},
    memberships    = length(module.oci_lz_groups) > 0 ? module.oci_lz_groups[0].memberships : {},
    dynamic_groups = length(module.oci_lz_dynamic_groups) > 0 ? module.oci_lz_dynamic_groups[0].dynamic_groups : {},
    policies       = length(module.oci_lz_policies) > 0 ? module.oci_lz_policies[0].policies : {}
  }
}

output "network_resources" {
  description = "Provisioned networking resources"
  value       = length(module.oci_lz_network) > 0 ? module.oci_lz_network[0].provisioned_networking_resources : null
}

output "observability_resources" {
  description = "Provisioned streaming resources"
  value = {
    # streams module
    streams = length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}
    stream_pools = length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].stream_pools : {}
    # events module
    events               = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].events : {}
    events_topics        = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].topics : {}
    events_subscriptions = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].subscriptions : {}
    events_streams       = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].streams : {}
    events_home_region   = length(module.oci_lz_home_region_events) > 0 ? module.oci_lz_home_region_events[0].events : {}
    # alarms module
    alarms               = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].alarms : {}
    alarms_topics        = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].topics : {}
    alarms_subscriptions = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].subscriptions : {}
    alarms_streams       = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].streams : {}
    # logging module
    log_groups               = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].log_groups : {}
    service_logs             = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].service_logs : {}
    custom_logs              = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].custom_logs : {}
    custom_logs_agent_config = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].custom_logs_agent_config : {}
    # notifications module
    notifications_topics        = length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}
    notifications_subscriptions = length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].subscriptions : {}
    # service connectors module
    service_connectors = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connectors : {}
    service_connector_buckets = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_buckets : {}
    service_connector_streams = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_streams : {}
    service_connector_topics  = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_topics : {}
    service_connector_policies = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_policies : {}
  }  
}

output "security_resources" {
  description = "Provisioned security resources"
  value = {
    keys = length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].keys : {}
    vaults = length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].vaults : {}
  }
}

output "governance_resources" {
  description = "Provisioned governance resources"
  value = {
    budgets = length(module.oci_lz_budgets) > 0 ? module.oci_lz_budgets[0].budgets : {}
    tags = length(module.oci_lz_tags) > 0 ? module.oci_lz_tags[0].tags : {}
  }
}

output "compute_resources" {
  description = "Provisioned compute resources"
  value = {
    instances = length(module.oci_lz_compute) > 0 ? module.oci_lz_compute[0].instances : {}
    secondary_vnics = length(module.oci_lz_compute) > 0 ? module.oci_lz_compute[0].secondary_vnics : {}
  }
}

output "nlb_resources" {
  description = "Provisioned NLB resources"
  value = {
    nlbs_private_ips = length(module.oci_lz_nlb) > 0 ? module.oci_lz_nlb[0].nlbs_private_ips : {}
  }
}

resource "local_file" "compartments_output" {
  lifecycle {
    prevent_destroy = true
  }
  count = var.output_path != null && length(module.oci_lz_compartments) > 0 ? 1 : 0
  content  = jsonencode({"compartments" : {for k, v in module.oci_lz_compartments[0].compartments : k => {"id" : v.id}}})
  filename = "${var.output_path}/compartments_output.json"
}

# TBD: add the output local files for all other outputs.