# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "http" "input_config_files_urls" {
  count = var.input_config_files_urls != null ? length(var.input_config_files_urls) : 0

  url = var.input_config_files_urls[count.index]

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  all_json_config_files = data.http.input_config_files_urls != null ? length(data.http.input_config_files_urls) > 0 ? [
    for element in flatten(data.http.input_config_files_urls[*].body) : jsondecode(element) if try(jsondecode(element), null) != null
  ] : null : null

  all_non_json_config_files = data.http.input_config_files_urls != null ? length(data.http.input_config_files_urls) > 0 ? [
    for element in flatten(data.http.input_config_files_urls[*]) : element.url if try(jsondecode(element.body), null) == null
  ] : null : null

  all_yaml_config_files = data.http.input_config_files_urls != null ? length(data.http.input_config_files_urls) > 0 ? [
    for element in flatten(data.http.input_config_files_urls[*].body) : yamldecode(element) if try(yamldecode(element), null) != null
  ] : null : null

  all_non_yaml_config_files = data.http.input_config_files_urls != null ? length(data.http.input_config_files_urls) > 0 ? [
    for element in flatten(data.http.input_config_files_urls[*]) : element.url if try(yamldecode(element.body), null) == null
  ] : null : null

  //all_non_json_non_yaml_config_files = merge(local.all_non_json_config_files, local.all_non_yaml_config_files)

  all_json_config_l1_keys = local.all_json_config_files != null ? length(local.all_json_config_files) > 0 ? flatten([
    for value in local.all_json_config_files : keys(value) if value != null
  ]) : null : null

  merged_input_json_config_files = local.all_json_config_l1_keys != null ? length(local.all_json_config_l1_keys) > 0 ? {
    for key in local.all_json_config_l1_keys : key => [
      for config in local.all_json_config_files : config[key] if contains(keys(config), key) && config != null
    ][0]
  } : null : null

  all_yaml_config_l1_keys = local.all_yaml_config_files != null ? length(local.all_yaml_config_files) > 0 ? flatten([
    for value in local.all_yaml_config_files : keys(value) if value != null
  ]) : null : null

  merged_input_yaml_config_files = local.all_yaml_config_l1_keys != null ? length(local.all_yaml_config_l1_keys) > 0 ? {
    for key in local.all_yaml_config_l1_keys : key => [
      for config in local.all_yaml_config_files : config[key] if contains(keys(config), key) && config != null
    ][0]
  } : null : null


  merged_input_config_files = merge(local.merged_input_json_config_files, local.merged_input_yaml_config_files)

  # IAM
  compartments_configuration_from_input_json_yaml_file   = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "compartments_configuration") ? local.merged_input_config_files.compartments_configuration : null : null
  groups_configuration_from_input_json_yaml_file         = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "groups_configuration") ? local.merged_input_config_files.groups_configuration : null : null
  dynamic_groups_configuration_from_input_json_yaml_file = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "dynamic_groups_configuration") ? local.merged_input_config_files.dynamic_groups_configuration : null : null
  policies_configuration_from_input_json_yaml_file       = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "policies_configuration") ? local.merged_input_config_files.policies_configuration : null : null

  # Networking - core
  network_configuration_from_input_json_yaml_file        = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "network_configuration") ? local.merged_input_config_files.network_configuration : null : null

  # Networking - firewall
  nlb_configuration_from_input_json_yaml_file            = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "nlb_configuration") ? local.merged_input_config_files.nlb_configuration : null : null
  instances_configuration_from_input_json_yaml_file      = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "instances_configuration") ? local.merged_input_config_files.instances_configuration : null : null

  # Observability
  streams_configuration_from_input_json_yaml_file            = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "streams_configuration") ? local.merged_input_config_files.streams_configuration : null : null
  service_connectors_configuration_from_input_json_yaml_file = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "service_connectors_configuration") ? local.merged_input_config_files.service_connectors_configuration : null : null
  logging_configuration_from_input_json_yaml_file            = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "logging_configuration") ? local.merged_input_config_files.logging_configuration : null : null
  notifications_configuration_from_input_json_yaml_file      = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "notifications_configuration") ? local.merged_input_config_files.notifications_configuration : null : null
  events_configuration_from_input_json_yaml_file             = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "events_configuration") ? local.merged_input_config_files.events_configuration : null : null
  home_region_events_configuration_from_input_json_yaml_file = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "home_region_events_configuration") ? local.merged_input_config_files.home_region_events_configuration : null : null
  alarms_configuration_from_input_json_yaml_file             = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "alarms_configuration") ? local.merged_input_config_files.alarms_configuration : null : null
}